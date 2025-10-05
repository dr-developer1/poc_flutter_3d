import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../data/solar_system_data.dart';
import '../widgets/celestial_body_3d_widget.dart';

/// Main screen displaying the solar system explorer
class SolarSystemScreen extends StatefulWidget {
  const SolarSystemScreen({super.key});

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen> {
  CelestialBody _selectedBody = SolarSystemData.sun;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar System Explorer'),
        centerTitle: true,
        elevation: 0,
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
            // 3D Viewer Section
            Expanded(
              flex: 3,
              child: Stack(
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
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Body Name Overlay
                  if (!_isLoading)
                    Positioned(top: 16, left: 16, child: _buildBodyNameCard()),
                ],
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

  /// Builds the body name card overlay
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

  /// Builds the information section with facts
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
            // Description
            Text(
              _selectedBody.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Facts Section
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

  /// Builds the horizontal planet selector
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
                _isLoading = true;
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

  /// Returns appropriate icon for body type
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

  /// Gets appropriate scale for different body types
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

  /// Gets appropriate camera radius for different body sizes
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

  /// Shows error snackbar
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
