import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated neural mesh background — subtle, premium, never distracting.
class NeuralBackground extends StatefulWidget {
  const NeuralBackground({super.key, this.child});

  final Widget? child;

  @override
  State<NeuralBackground> createState() => _NeuralBackgroundState();
}

class _NeuralBackgroundState extends State<NeuralBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.gradientHero,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _NeuralMeshPainter(progress: _controller.value),
              size: Size.infinite,
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.6),
              radius: 1.2,
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _NeuralMeshPainter extends CustomPainter {
  _NeuralMeshPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    const nodeCount = 12;
    final nodes = List.generate(nodeCount, (i) {
      final angle = (i / nodeCount) * 2 * pi + progress * 2 * pi;
      final radius = size.shortestSide * (0.25 + (i % 3) * 0.08);
      return Offset(
        size.width / 2 + cos(angle) * radius,
        size.height * 0.35 + sin(angle) * radius * 0.6,
      );
    });

    final linePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    final nodePaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.15);

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        if (random.nextDouble() > 0.55) continue;
        canvas.drawLine(nodes[i], nodes[j], linePaint);
      }
    }

    for (final node in nodes) {
      canvas.drawCircle(node, 2.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_NeuralMeshPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
