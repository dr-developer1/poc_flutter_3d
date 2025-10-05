import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../data/solar_system_data.dart';
import '../widgets/celestial_body_3d_widget.dart';
import '../widgets/orbital_system_view.dart';
import '../widgets/time_control_widget.dart';
import 'comparison_screen.dart';

enum ViewMode { model3D, orbital }

/// Main screen displaying the solar system explorer with dual view modes
class SolarSystemExplorerScreen extends StatefulWidget {
  const SolarSystemExplorerScreen({super.key});

  @override
  State<SolarSystemExplorerScreen> createState() =>
      _SolarSystemExplorerScreenState();
}

class _SolarSystemExplorerScreenState extends State<SolarSystemExplorerScreen> {
  CelestialBody _selectedBody = SolarSystemData.sun;
  bool _isLoading = true;
  ViewMode _viewMode = ViewMode.model3D;
  double _timeScale = 10.0;
  bool _isPaused = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar System Explorer'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Comparison mode
          IconButton(
            icon: const Icon(Icons.compare),
            tooltip: 'Compare Planets',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComparisonScreen(),
                ),
              );
            },
          ),
          // View mode toggle
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.model3D ? Icons.public : Icons.view_in_ar,
            ),
            tooltip: _viewMode == ViewMode.model3D
                ? 'Orbital View'
                : '3D Model View',
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.model3D
                    ? ViewMode.orbital
                    : ViewMode.model3D;
                if (_viewMode == ViewMode.model3D) {
                  _isLoading = true;
                }
              });
            },
          ),
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0F12), Color(0xFF1A2A3A), Color(0xFF0F1419)],
          ),
        ),
        child: Column(
          children: [
            // Main viewing area
            Expanded(
              flex: 3,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _viewMode == ViewMode.model3D
                    ? _build3DModelView()
                    : _buildOrbitalView(),
              ),
            ),

            // Time control (shown in orbital view)
            if (_viewMode == ViewMode.orbital)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TimeControlWidget(
                  timeScale: _timeScale,
                  isPaused: _isPaused,
                  onTimeScaleChanged: (value) {
                    setState(() => _timeScale = value);
                  },
                  onPlayPauseToggle: () {
                    setState(() => _isPaused = !_isPaused);
                  },
                ),
              ),

            // Information Section
            Expanded(flex: 2, child: _buildInformationSection()),

            // Planet Selector
            _buildPlanetSelector(),
          ],
        ),
      ),
    );
  }

  Widget _build3DModelView() {
    return Stack(
      key: const ValueKey('3d_view'),
      children: [
        // 3D Model
        CelestialBody3DWidget(
          key: ValueKey(_selectedBody.name),
          body: _selectedBody,
          scale: _getScaleForBody(_selectedBody),
          cameraOrbitRadius: _getCameraRadiusForBody(_selectedBody),
          onLoad: () {
            setState(() => _isLoading = false);
          },
          onError: (error) {
            setState(() => _isLoading = false);
            _showErrorSnackBar(error);
          },
        ),

        // Loading Indicator
        if (_isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: _selectedBody.color),
                const SizedBox(height: 16),
                Text(
                  'Loading ${_selectedBody.name}...',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

        // Body Name Overlay
        if (!_isLoading)
          Positioned(top: 16, left: 16, child: _buildBodyNameCard()),

        // View mode hint
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.public, color: Colors.cyan, size: 16),
                SizedBox(width: 6),
                Text(
                  'Tap icon for orbital view',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrbitalView() {
    return Stack(
      key: const ValueKey('orbital_view'),
      children: [
        OrbitalSystemView(
          selectedBody: _selectedBody,
          onBodyTapped: (body) {
            setState(() {
              _selectedBody = body;
              if (_viewMode == ViewMode.model3D) {
                _isLoading = true;
              }
            });
          },
          timeScale: _isPaused ? 0 : _timeScale,
        ),

        // View mode hint
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, color: Colors.cyan, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Tap planets to select',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_in_ar, color: Colors.cyan, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Tap icon for 3D view',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyNameCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _selectedBody.color.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForBodyType(_selectedBody.type),
            color: _selectedBody.color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            _selectedBody.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: _selectedBody.color.withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedBody.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedBody.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedBody.facts.isNotEmpty) ...[
              const Text(
                'Interesting Facts:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._selectedBody.facts.map(
                (fact) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: _selectedBody.color, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fact,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetSelector() {
    final allBodies = [
      SolarSystemData.sun,
      ...SolarSystemData.planets,
      SolarSystemData.moon,
    ];

    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allBodies.length,
        itemBuilder: (context, index) {
          final body = allBodies[index];
          final isSelected = body == _selectedBody;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBody = body;
                if (_viewMode == ViewMode.model3D) {
                  _isLoading = true;
                }
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? body.color.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? body.color
                      : Colors.white.withValues(alpha: 0.2),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForBodyType(body.type),
                    color: isSelected ? body.color : Colors.white60,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2A3A),
        title: const Text(
          'Search Celestial Bodies',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter planet name...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: const Icon(Icons.search, color: Colors.cyan),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan.withValues(alpha: 0.5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
            ),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value.toLowerCase());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.cyan)),
          ),
          TextButton(
            onPressed: () {
              final allBodies = [
                SolarSystemData.sun,
                ...SolarSystemData.planets,
                SolarSystemData.moon,
              ];

              final found = allBodies
                  .where(
                    (body) => body.name.toLowerCase().contains(_searchQuery),
                  )
                  .toList();

              if (found.isNotEmpty) {
                setState(() {
                  _selectedBody = found.first;
                  if (_viewMode == ViewMode.model3D) {
                    _isLoading = true;
                  }
                });
              }

              Navigator.pop(context);
              _searchController.clear();
            },
            child: const Text('Search', style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForBodyType(CelestialBodyType type) {
    switch (type) {
      case CelestialBodyType.star:
        return Icons.wb_sunny;
      case CelestialBodyType.planet:
        return Icons.public;
      case CelestialBodyType.moon:
        return Icons.brightness_3;
      case CelestialBodyType.asteroid:
        return Icons.grain;
    }
  }

  double _getScaleForBody(CelestialBody body) {
    switch (body.type) {
      case CelestialBodyType.star:
        return 1.5;
      case CelestialBodyType.planet:
        return body.size > 5 ? 1.2 : 1.0;
      case CelestialBodyType.moon:
        return 0.8;
      case CelestialBodyType.asteroid:
        return 0.5;
    }
  }

  double _getCameraRadiusForBody(CelestialBody body) {
    if (body.type == CelestialBodyType.star) {
      return 5.0;
    } else if (body.size > 5) {
      return 4.5;
    } else if (body.size > 1) {
      return 3.5;
    } else {
      return 2.5;
    }
  }

  void _showErrorSnackBar(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error loading model: $error'),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}
