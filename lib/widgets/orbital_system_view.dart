import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../data/solar_system_data.dart';

/// Widget that displays a 2D top-down view of the solar system
/// with animated orbital motion
class OrbitalSystemView extends StatefulWidget {
  final CelestialBody? selectedBody;
  final Function(CelestialBody)? onBodyTapped;
  final double timeScale;

  const OrbitalSystemView({
    super.key,
    this.selectedBody,
    this.onBodyTapped,
    this.timeScale = 1.0,
  });

  @override
  State<OrbitalSystemView> createState() => _OrbitalSystemViewState();
}

class _OrbitalSystemViewState extends State<OrbitalSystemView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Map<String, double> _orbitalAngles = {};

  @override
  void initState() {
    super.initState();

    // Initialize orbital angles
    for (var planet in SolarSystemData.planets) {
      _orbitalAngles[planet.name] = Random().nextDouble() * 2 * pi;
    }

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // Base orbital period
    )..repeat();

    _animationController.addListener(() {
      setState(() {
        _updateOrbitalPositions();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OrbitalSystemView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation speed when timeScale changes
    if (oldWidget.timeScale != widget.timeScale) {
      final newDuration = Duration(
        milliseconds: (60000 / widget.timeScale).round(),
      );
      _animationController.duration = newDuration;
    }
  }

  void _updateOrbitalPositions() {
    for (var planet in SolarSystemData.planets) {
      // Calculate angular velocity based on orbital speed
      // Faster planets (closer to sun) move faster
      final angularVelocity = planet.orbitalSpeed / 30.0 * widget.timeScale;
      _orbitalAngles[planet.name] =
          (_orbitalAngles[planet.name]! + angularVelocity * 0.01) % (2 * pi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final centerX = size.width / 2;
        final centerY = size.height / 2;
        final maxRadius = min(centerX, centerY) * 0.9;

        return GestureDetector(
          onTapUp: (details) => _handleTap(
            details.localPosition,
            size,
            centerX,
            centerY,
            maxRadius,
          ),
          child: CustomPaint(
            size: size,
            painter: OrbitalSystemPainter(
              planets: SolarSystemData.planets,
              orbitalAngles: _orbitalAngles,
              selectedBody: widget.selectedBody,
              centerX: centerX,
              centerY: centerY,
              maxRadius: maxRadius,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(
    Offset position,
    Size size,
    double centerX,
    double centerY,
    double maxRadius,
  ) {
    // Check if tap hit any planet
    for (var planet in SolarSystemData.planets) {
      final angle = _orbitalAngles[planet.name]!;
      final distance = planet.distanceFromSun * maxRadius / 30.0;

      final planetX = centerX + cos(angle) * distance;
      final planetY = centerY + sin(angle) * distance;

      final dx = position.dx - planetX;
      final dy = position.dy - planetY;
      final distanceToTap = sqrt(dx * dx + dy * dy);

      // Planet size for hit detection
      final planetRadius = max(8.0, planet.size * 3);

      if (distanceToTap < planetRadius) {
        widget.onBodyTapped?.call(planet);
        return;
      }
    }

    // Check if sun was tapped
    final dxToSun = position.dx - centerX;
    final dyToSun = position.dy - centerY;
    final distanceToSun = sqrt(dxToSun * dxToSun + dyToSun * dyToSun);

    if (distanceToSun < 30) {
      widget.onBodyTapped?.call(SolarSystemData.sun);
    }
  }
}

/// Custom painter for the orbital system
class OrbitalSystemPainter extends CustomPainter {
  final List<CelestialBody> planets;
  final Map<String, double> orbitalAngles;
  final CelestialBody? selectedBody;
  final double centerX;
  final double centerY;
  final double maxRadius;

  OrbitalSystemPainter({
    required this.planets,
    required this.orbitalAngles,
    required this.selectedBody,
    required this.centerX,
    required this.centerY,
    required this.maxRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background stars
    _drawStars(canvas, size);

    // Draw orbital paths
    _drawOrbitalPaths(canvas);

    // Draw the Sun
    _drawSun(canvas);

    // Draw planets
    _drawPlanets(canvas);

    // Draw labels for selected body
    if (selectedBody != null &&
        selectedBody!.type == CelestialBodyType.planet) {
      _drawLabel(canvas, selectedBody!);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent stars
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawOrbitalPaths(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var planet in planets) {
      final distance = planet.distanceFromSun * maxRadius / 30.0;

      // Use planet's color with low opacity for orbit
      paint.color = planet.color.withValues(alpha: 0.2);

      canvas.drawCircle(Offset(centerX, centerY), distance, paint);
    }
  }

  void _drawSun(Canvas canvas) {
    final isSelected = selectedBody?.name == 'Sun';

    // Draw glow
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFFFDB813).withValues(alpha: 0.6),
              const Color(0xFFFDB813).withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: 40),
          );
    canvas.drawCircle(Offset(centerX, centerY), 40, glowPaint);

    // Draw sun body
    final sunPaint = Paint()
      ..color = const Color(0xFFFDB813)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 25, sunPaint);

    // Draw selection ring
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(centerX, centerY), 30, selectionPaint);
    }
  }

  void _drawPlanets(Canvas canvas) {
    for (var planet in planets) {
      final angle = orbitalAngles[planet.name]!;
      final distance = planet.distanceFromSun * maxRadius / 30.0;

      final x = centerX + cos(angle) * distance;
      final y = centerY + sin(angle) * distance;

      final isSelected = selectedBody?.name == planet.name;

      // Planet size (scaled for visibility)
      final radius = max(4.0, min(planet.size * 2, 12.0));

      // Draw planet glow if selected
      if (isSelected) {
        final glowPaint = Paint()
          ..shader =
              RadialGradient(
                colors: [
                  planet.color.withValues(alpha: 0.6),
                  planet.color.withValues(alpha: 0.0),
                ],
              ).createShader(
                Rect.fromCircle(center: Offset(x, y), radius: radius * 3),
              );
        canvas.drawCircle(Offset(x, y), radius * 3, glowPaint);
      }

      // Draw planet
      final planetPaint = Paint()
        ..color = planet.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), radius, planetPaint);

      // Draw selection ring
      if (isSelected) {
        final selectionPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(Offset(x, y), radius + 4, selectionPaint);
      }
    }
  }

  void _drawLabel(Canvas canvas, CelestialBody body) {
    final angle = orbitalAngles[body.name]!;
    final distance = body.distanceFromSun * maxRadius / 30.0;

    final x = centerX + cos(angle) * distance;
    final y = centerY + sin(angle) * distance;

    final textSpan = TextSpan(
      text: body.name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 0)),
        ],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textOffset = Offset(
      x - textPainter.width / 2,
      y - textPainter.height - 20,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(OrbitalSystemPainter oldDelegate) {
    return true; // Always repaint for animations
  }
}
