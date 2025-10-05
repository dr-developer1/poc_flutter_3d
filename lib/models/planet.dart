import 'package:flutter/material.dart';

/// Represents a celestial body in the solar system
class CelestialBody {
  /// Name of the celestial body
  final String name;

  /// Relative size compared to Earth (Earth = 1.0)
  final double size;

  /// Distance from the sun in AU (Astronomical Units, Earth = 1.0 AU)
  final double distanceFromSun;

  /// Orbital speed in km/s
  final double orbitalSpeed;

  /// Path to the 3D model asset
  final String modelPath;

  /// Primary color of the celestial body
  final Color color;

  /// Interesting facts about the celestial body
  final List<String> facts;

  /// Type of celestial body
  final CelestialBodyType type;

  const CelestialBody({
    required this.name,
    required this.size,
    required this.distanceFromSun,
    required this.orbitalSpeed,
    required this.modelPath,
    required this.color,
    required this.facts,
    required this.type,
  });

  /// Returns a display-friendly description
  String get description {
    if (type == CelestialBodyType.star) {
      return 'Our Sun - The center of the solar system';
    } else if (type == CelestialBodyType.planet) {
      return 'Distance: ${distanceFromSun.toStringAsFixed(2)} AU | Orbital Speed: ${orbitalSpeed.toStringAsFixed(1)} km/s';
    } else {
      return 'Asteroid - Space rock orbiting the sun';
    }
  }

  @override
  String toString() => 'CelestialBody(name: $name, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CelestialBody &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Types of celestial bodies
enum CelestialBodyType { star, planet, moon, asteroid }
