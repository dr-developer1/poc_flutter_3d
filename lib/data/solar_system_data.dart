import 'package:flutter/material.dart';
import '../models/planet.dart';

/// Solar System data repository
/// Contains all celestial bodies with scientifically accurate relative data
class SolarSystemData {
  SolarSystemData._();

  /// The Sun - center of our solar system
  static const CelestialBody sun = CelestialBody(
    name: 'Sun',
    size: 109.0, // 109 times Earth's diameter
    distanceFromSun: 0.0,
    orbitalSpeed: 0.0,
    modelPath: 'assets/models/sun.glb',
    color: Color(0xFFFDB813),
    type: CelestialBodyType.star,
    facts: [
      'The Sun contains 99.86% of the mass in the Solar System',
      'Temperatures in the core reach 15 million °C',
      'One million Earths could fit inside the Sun',
      'The Sun is 4.6 billion years old',
    ],
  );

  /// All planets in the solar system (ordered by distance from sun)
  static const List<CelestialBody> planets = [
    // Mercury
    CelestialBody(
      name: 'Mercury',
      size: 0.38, // Relative to Earth
      distanceFromSun: 0.39, // AU
      orbitalSpeed: 47.87,
      modelPath: 'assets/models/mercury.glb',
      color: Color(0xFF8C7853),
      type: CelestialBodyType.planet,
      facts: [
        'Smallest planet in the solar system',
        'One day on Mercury lasts 59 Earth days',
        'Surface temperature ranges from -173°C to 427°C',
        'Has no atmosphere to retain heat',
      ],
    ),

    // Venus
    CelestialBody(
      name: 'Venus',
      size: 0.95,
      distanceFromSun: 0.72,
      orbitalSpeed: 35.02,
      modelPath: 'assets/models/venus.glb',
      color: Color(0xFFFFC649),
      type: CelestialBodyType.planet,
      facts: [
        'Hottest planet in the solar system',
        'Rotates in the opposite direction to most planets',
        'A day on Venus is longer than a year',
        'Atmospheric pressure is 92 times that of Earth',
      ],
    ),

    // Earth
    CelestialBody(
      name: 'Earth',
      size: 1.0,
      distanceFromSun: 1.0,
      orbitalSpeed: 29.78,
      modelPath: 'assets/models/earth.glb',
      color: Color(0xFF4A90E2),
      type: CelestialBodyType.planet,
      facts: [
        'The only planet known to support life',
        '71% of surface is covered by water',
        'Has one natural satellite: the Moon',
        'Formed approximately 4.54 billion years ago',
      ],
    ),

    // Mars
    CelestialBody(
      name: 'Mars',
      size: 0.53,
      distanceFromSun: 1.52,
      orbitalSpeed: 24.07,
      modelPath: 'assets/models/mars.glb',
      color: Color(0xFFCD5C5C),
      type: CelestialBodyType.planet,
      facts: [
        'Known as the Red Planet',
        'Has the largest volcano in the solar system: Olympus Mons',
        'A day on Mars is 24.6 hours',
        'Has two small moons: Phobos and Deimos',
      ],
    ),

    // Jupiter
    CelestialBody(
      name: 'Jupiter',
      size: 11.2,
      distanceFromSun: 5.2,
      orbitalSpeed: 13.07,
      modelPath: 'assets/models/jupiter.glb',
      color: Color(0xFFC88B3A),
      type: CelestialBodyType.planet,
      facts: [
        'Largest planet in the solar system',
        'Has 95 known moons',
        'The Great Red Spot is a storm larger than Earth',
        'A day on Jupiter is only 10 hours',
      ],
    ),

    // Saturn - using available model
    CelestialBody(
      name: 'Saturn',
      size: 9.45,
      distanceFromSun: 9.54,
      orbitalSpeed: 9.69,
      modelPath: 'assets/models/saturn.glb',
      color: Color(0xFFFAD5A5),
      type: CelestialBodyType.planet,
      facts: [
        'Famous for its prominent ring system',
        'Has 146 known moons',
        'Least dense planet - could float in water',
        'Wind speeds can reach 1,800 km/h',
      ],
    ),

    // Uranus
    CelestialBody(
      name: 'Uranus',
      size: 4.0,
      distanceFromSun: 19.19,
      orbitalSpeed: 6.81,
      modelPath: 'assets/models/uranus.glb',
      color: Color(0xFF4FD0E7),
      type: CelestialBodyType.planet,
      facts: [
        'Rotates on its side at 98° angle',
        'Coldest planetary atmosphere in the solar system',
        'Has 27 known moons',
        'Made of water, methane, and ammonia ices',
      ],
    ),

    // Neptune
    CelestialBody(
      name: 'Neptune',
      size: 3.88,
      distanceFromSun: 30.07,
      orbitalSpeed: 5.43,
      modelPath: 'assets/models/neptune.glb',
      color: Color(0xFF4169E1),
      type: CelestialBodyType.planet,
      facts: [
        'Farthest planet from the Sun',
        'Has the strongest winds in the solar system',
        'Takes 165 Earth years to orbit the Sun',
        'Has 14 known moons',
      ],
    ),
  ];

  /// Moon of Earth
  static const CelestialBody moon = CelestialBody(
    name: 'Moon',
    size: 0.27,
    distanceFromSun: 1.0, // Orbits Earth, not Sun directly
    orbitalSpeed: 1.02,
    modelPath: 'assets/models/moon.glb',
    color: Color(0xFFD3D3D3),
    type: CelestialBodyType.moon,
    facts: [
      'Earth\'s only natural satellite',
      'Same side always faces Earth',
      'Causes ocean tides on Earth',
      'Formed about 4.5 billion years ago',
    ],
  );

  /// Asteroids scattered around the solar system
  static const List<CelestialBody> asteroids = [
    CelestialBody(
      name: 'Asteroid 1',
      size: 0.001,
      distanceFromSun: 2.2,
      orbitalSpeed: 20.0,
      modelPath: 'assets/models/asteroid_1.glb',
      color: Color(0xFF696969),
      type: CelestialBodyType.asteroid,
      facts: ['Space rock in the asteroid belt'],
    ),
    CelestialBody(
      name: 'Asteroid 2',
      size: 0.001,
      distanceFromSun: 2.5,
      orbitalSpeed: 18.5,
      modelPath: 'assets/models/asteroid_2.glb',
      color: Color(0xFF696969),
      type: CelestialBodyType.asteroid,
      facts: ['Space rock in the asteroid belt'],
    ),
    CelestialBody(
      name: 'Asteroid 3',
      size: 0.0008,
      distanceFromSun: 2.8,
      orbitalSpeed: 17.0,
      modelPath: 'assets/models/asteroid_3.glb',
      color: Color(0xFF696969),
      type: CelestialBodyType.asteroid,
      facts: ['Space rock in the asteroid belt'],
    ),
    CelestialBody(
      name: 'Asteroid 4',
      size: 0.0012,
      distanceFromSun: 3.0,
      orbitalSpeed: 16.5,
      modelPath: 'assets/models/asteroid_4.glb',
      color: Color(0xFF696969),
      type: CelestialBodyType.asteroid,
      facts: ['Space rock in the asteroid belt'],
    ),
    CelestialBody(
      name: 'Asteroid 5',
      size: 0.0009,
      distanceFromSun: 3.2,
      orbitalSpeed: 16.0,
      modelPath: 'assets/models/asteroid_5.glb',
      color: Color(0xFF696969),
      type: CelestialBodyType.asteroid,
      facts: ['Space rock in the asteroid belt'],
    ),
  ];

  /// Returns all celestial bodies in the solar system
  static List<CelestialBody> getAllBodies() {
    return [sun, ...planets, moon, ...asteroids];
  }

  /// Returns only planets (excluding sun, moon, and asteroids)
  static List<CelestialBody> getPlanetsOnly() {
    return planets;
  }

  /// Returns planets in the inner solar system (Mercury to Mars)
  static List<CelestialBody> getInnerPlanets() {
    return planets.where((p) => p.distanceFromSun < 2.0).toList();
  }

  /// Returns planets in the outer solar system (Jupiter to Neptune)
  static List<CelestialBody> getOuterPlanets() {
    return planets.where((p) => p.distanceFromSun >= 2.0).toList();
  }
}
