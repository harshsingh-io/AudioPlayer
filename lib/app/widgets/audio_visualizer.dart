import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioVisualizer extends StatefulWidget {
  final bool isPlaying;
  final AudioPlayer audioPlayer;
  final String audioUrl;

  const AudioVisualizer({
    super.key,
    required this.isPlaying,
    required this.audioPlayer,
    required this.audioUrl,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  final List<double> _barHeights = [];
  double _progress = 0.0;
  final int totalBars = 50;

  @override
  void initState() {
    super.initState();
    _generateBarHeights();
    _setupProgressListener();
  }

  void _generateBarHeights() {
    final random = Random();
    _barHeights.clear();
    for (int i = 0; i < totalBars; i++) {
      // Create more natural-looking variations
      double height = 0.5; // Base height

      // Add some random variations
      height += random.nextDouble() * 0.5; // Random addition up to 0.5

      // Add periodic variations to create a wave-like pattern
      height += sin(i * 0.2) * 0.2; // Sine wave variation

      // Ensure height is within bounds
      height = height.clamp(0.3, 1.0);

      _barHeights.add(height);
    }
  }

  void _setupProgressListener() {
    widget.audioPlayer.positionStream.listen((position) {
      if (widget.audioPlayer.duration != null) {
        setState(() {
          _progress = position.inMilliseconds /
              widget.audioPlayer.duration!.inMilliseconds;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final pos = box.globalToLocal(details.globalPosition);
        final percent = (pos.dx / box.size.width).clamp(0.0, 1.0);

        if (widget.audioPlayer.duration != null) {
          final newPosition = widget.audioPlayer.duration! * percent;
          widget.audioPlayer.seek(newPosition);
        }
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 100),
        painter: WaveformPainter(
          barHeights: _barHeights,
          progress: _progress,
          isPlaying: widget.isPlaying,
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> barHeights;
  final double progress;
  final bool isPlaying;

  WaveformPainter({
    required this.barHeights,
    required this.progress,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barWidth = 3.0;
    final spacing =
        (size.width - (barHeights.length * barWidth)) / (barHeights.length - 1);
    final progressWidth = size.width * progress;

    for (var i = 0; i < barHeights.length; i++) {
      final left = i * (barWidth + spacing);
      final height = barHeights[i] * size.height;
      final center = size.height / 2;
      final barHeight = height * 0.5;

      // Draw the top half of the bar
      final topRect =
          Rect.fromLTWH(left, center - barHeight, barWidth, barHeight);

      // Draw the bottom half of the bar
      final bottomRect = Rect.fromLTWH(left, center, barWidth, barHeight);

      // Determine if this bar is before or after the progress point
      if (left <= progressWidth) {
        paint.color = Colors.white;
      } else {
        paint.color = Colors.grey;
      }

      // Draw both halves of the bar
      canvas.drawRect(topRect, paint);
      canvas.drawRect(bottomRect, paint);
    }

    // Draw progress bar line
    final progressLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(progressWidth, 0),
        Offset(progressWidth, size.height), progressLinePaint);
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        isPlaying != oldDelegate.isPlaying;
  }
}
