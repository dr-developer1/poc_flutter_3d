import 'package:flutter/material.dart';

/// Widget for controlling simulation time speed
class TimeControlWidget extends StatelessWidget {
  final double timeScale;
  final bool isPaused;
  final ValueChanged<double> onTimeScaleChanged;
  final VoidCallback onPlayPauseToggle;

  const TimeControlWidget({
    super.key,
    required this.timeScale,
    required this.isPaused,
    required this.onTimeScaleChanged,
    required this.onPlayPauseToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and play/pause button
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.cyan, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Time Control',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.cyan,
                ),
                onPressed: onPlayPauseToggle,
                tooltip: isPaused ? 'Play' : 'Pause',
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Time scale slider
          Row(
            children: [
              const Text(
                '1x',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.cyan,
                    inactiveTrackColor: Colors.cyan.withValues(alpha: 0.3),
                    thumbColor: Colors.cyanAccent,
                    overlayColor: Colors.cyan.withValues(alpha: 0.2),
                    trackHeight: 3.0,
                  ),
                  child: Slider(
                    value: _timeScaleToSliderValue(timeScale),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (value) {
                      onTimeScaleChanged(_sliderValueToTimeScale(value));
                    },
                  ),
                ),
              ),
              Text(
                '${timeScale.toStringAsFixed(0)}x',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),

          // Quick preset buttons
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton('1x', 1.0),
              _buildPresetButton('10x', 10.0),
              _buildPresetButton('50x', 50.0),
              _buildPresetButton('100x', 100.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, double scale) {
    final isActive = (timeScale - scale).abs() < 0.5;

    return GestureDetector(
      onTap: () => onTimeScaleChanged(scale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.cyan.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.cyan : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.cyan : Colors.white70,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Converts time scale to slider value (non-linear for better control)
  double _timeScaleToSliderValue(double timeScale) {
    if (timeScale <= 1) return 0;
    if (timeScale <= 10) return (timeScale - 1) * 10;
    if (timeScale <= 100) return 90 + (timeScale - 10) / 9;
    return 100;
  }

  /// Converts slider value to time scale (non-linear)
  double _sliderValueToTimeScale(double value) {
    if (value <= 0) return 1;
    if (value <= 90) return 1 + value / 10;
    return 10 + (value - 90) * 9;
  }
}
