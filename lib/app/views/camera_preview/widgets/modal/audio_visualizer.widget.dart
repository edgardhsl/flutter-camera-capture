import 'package:flutter/material.dart';
import 'dart:math';

class AudioVisualizer extends StatelessWidget {
  final List<int> data; // Uint8Array converted to List<int>
  final double threshold;

  const AudioVisualizer({super.key, required this.data, required this.threshold});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AudioVisualizerPainter(data: data, threshold: threshold),
    );
  }
}

class AudioVisualizerPainter extends CustomPainter {
  final List<int> data;
  final double threshold;

  const AudioVisualizerPainter({required this.data, required this.threshold});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // Adjust styles as needed

    final maxBinCount = data.length;
    const space = 3.0; // Adjust spacing as needed

    double radius = 0.0; // Calculate radius based on your requirements

    double barLengthFactor = 1.0;
    if (size.width >= 785) {
      barLengthFactor = 1.0;
    } else if (size.width < 785) {
      barLengthFactor = 1.5;
    } else if (size.width < 500) {
      barLengthFactor = 20.0;
    }

    final path = Path();
    for (int i = 0; i < maxBinCount; i++) {
      final value = data[i];
      if (value >= threshold) {
        final barWidth = size.width <= 450 ? 2.0 : 3.0;
        final barHeight = -value / barLengthFactor; // Adjust calculation as needed
        final x = i * space.toDouble();
        path.moveTo(x, radius);
        path.lineTo(x + barWidth, radius);
        path.lineTo(x + barWidth, radius + barHeight);
        path.lineTo(x, radius + barHeight);
        path.close();
        canvas.drawPath(path, paint); // Draw the bar
        //path.clear(); // Clear the path for the next bar
        canvas.rotate((pi / 128) * 180); // Adjust rotation as needed
      }
    }
  }

  @override
  bool shouldRepaint(AudioVisualizerPainter oldDelegate) => data != oldDelegate.data;
}
