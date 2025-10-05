import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/planet.dart';
import '../data/solar_system_data.dart';

/// Screen for comparing multiple celestial bodies side by side
class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final List<CelestialBody> _selectedBodies = [
    SolarSystemData.planets[2], // Earth
    SolarSystemData.planets[3], // Mars
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planet Comparison'),
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
            // Selection area
            _buildSelectionArea(),

            const Divider(color: Colors.cyan, thickness: 1),

            // Comparison content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Size comparison
                    _buildSizeComparison(),

                    const SizedBox(height: 24),

                    // Stats comparison table
                    _buildStatsTable(),

                    const SizedBox(height: 24),

                    // Facts comparison
                    _buildFactsComparison(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select celestial bodies to compare:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildBodySelector(0)),
              const SizedBox(width: 12),
              const Icon(Icons.compare_arrows, color: Colors.cyan),
              const SizedBox(width: 12),
              Expanded(child: _buildBodySelector(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodySelector(int index) {
    final body = _selectedBodies[index];

    return GestureDetector(
      onTap: () => _showBodyPicker(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: body.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: body.color, width: 2),
        ),
        child: Row(
          children: [
            Icon(_getIconForBodyType(body.type), color: body.color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    body.type.name.toUpperCase(),
                    style: TextStyle(color: body.color, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeComparison() {
    final maxSize = _selectedBodies.map((b) => b.size).reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.straighten, color: Colors.cyan, size: 20),
              SizedBox(width: 8),
              Text(
                'Size Comparison',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._selectedBodies.map((body) {
            final widthPercent = (body.size / maxSize) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          body.name,
                          style: TextStyle(
                            color: body.color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: widthPercent,
                              decoration: BoxDecoration(
                                color: body.color.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${body.size.toStringAsFixed(2)}x',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Sizes relative to Earth (1.0)',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.table_chart, color: Colors.cyan, size: 20),
              SizedBox(width: 8),
              Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Distance from Sun',
            _selectedBodies
                .map((b) => '${b.distanceFromSun.toStringAsFixed(2)} AU')
                .toList(),
          ),
          _buildStatRow(
            'Orbital Speed',
            _selectedBodies
                .map((b) => '${b.orbitalSpeed.toStringAsFixed(1)} km/s')
                .toList(),
          ),
          _buildStatRow(
            'Relative Size',
            _selectedBodies
                .map((b) => '${b.size.toStringAsFixed(2)}x Earth')
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          ...values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final body = _selectedBodies[index];

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: body.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: body.color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: body.color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFactsComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.cyan, size: 20),
              SizedBox(width: 8),
              Text(
                'Interesting Facts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _selectedBodies.map((body) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body.name,
                        style: TextStyle(
                          color: body.color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...body.facts
                          .take(3)
                          .map(
                            (fact) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.star, color: body.color, size: 14),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      fact,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showBodyPicker(int index) {
    final allBodies = [
      SolarSystemData.sun,
      ...SolarSystemData.planets,
      SolarSystemData.moon,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2A3A),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a celestial body',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: allBodies.length,
                itemBuilder: (context, i) {
                  final body = allBodies[i];
                  return ListTile(
                    leading: Icon(
                      _getIconForBodyType(body.type),
                      color: body.color,
                    ),
                    title: Text(
                      body.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      body.type.name,
                      style: TextStyle(color: body.color),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedBodies[index] = body;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
}
