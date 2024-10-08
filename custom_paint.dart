import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ThemeChangeDemo extends StatefulWidget {
  const ThemeChangeDemo({super.key});
  @override
  State<ThemeChangeDemo> createState() => _ThemeChangeDemoState();
}

class _ThemeChangeDemoState extends State<ThemeChangeDemo> with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Paint"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(animation:_controller , builder: (BuildContext context, Widget? child) {
            return  Center(child: CustomPaint(painter: WavePainter(animationValue: _controller.value),size: const Size(200, 200),));
          },),
          SizedBox(height: 20,),
          CustomPaint(painter: SemiCircleProgressPainter(progress: 0.75),size: Size(200, 200),)
        ],
      ),
    );
  }
}

class SemiCircleProgressPainter extends CustomPainter {
  final double progress; // Progress as a value between 0 and 1

  SemiCircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height), radius: size.width / 2
      )
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Draw background semi-circle (for the track)
    Paint trackPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Define the center point and radius
    Offset center = Offset(size.width / 2, size.height);
    double radius = size.width / 2;

    // Draw the background track (full semi-circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Starting from the left (pi radians)
      pi, // Draw a half-circle (pi radians)
      false,
      trackPaint,
    );

    // Draw the progress arc based on the progress percentage
    double sweepAngle = pi * progress; // The progress part to draw
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Starting from the left
      sweepAngle, // Sweep based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Path wavePath = Path();

    double waveHeight = 20;
    double waveLength = size.width / 1.5;

    // Start drawing from the left bottom corner
    wavePath.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / waveLength * 2 * pi) + (animationValue * 2 * pi)) * waveHeight + size.height / 2;
      wavePath.lineTo(i, y);
    }

    // Complete the wave path to cover the bottom of the screen
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // Draw the wave on the canvas
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


