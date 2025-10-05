import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../models/planet.dart';

/// Widget that displays a single 3D celestial body
class CelestialBody3DWidget extends StatefulWidget {
  final CelestialBody body;
  final double scale;
  final double cameraOrbitRadius;
  final VoidCallback? onLoad;
  final Function(String)? onError;

  const CelestialBody3DWidget({
    super.key,
    required this.body,
    this.scale = 1.0,
    this.cameraOrbitRadius = 3.5,
    this.onLoad,
    this.onError,
  });

  @override
  State<CelestialBody3DWidget> createState() => _CelestialBody3DWidgetState();
}

class _CelestialBody3DWidgetState extends State<CelestialBody3DWidget> {
  late Flutter3DController controller;

  @override
  void initState() {
    super.initState();
    controller = Flutter3DController();
  }

  @override
  void dispose() {
    // Flutter3DController doesn't need explicit disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flutter3DViewer(
      src: widget.body.modelPath,
      controller: controller,
      progressBarColor: widget.body.color,
      onLoad: (String modelPath) {
        // Set camera position based on body size
        final cameraRadius = widget.cameraOrbitRadius * widget.scale;
        controller.setCameraTarget(0.0, 0.0, 0.0);
        controller.setCameraOrbit(0.0, 75.0, cameraRadius);

        widget.onLoad?.call();
      },
      onError: (String error) {
        debugPrint('Failed to load ${widget.body.name}: $error');
        widget.onError?.call(error);
      },
    );
  }
}
