import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';

class RainbowBorder extends StatefulWidget {
  final double borderWidth;
  final double borderRadius;
  final Duration duration;
  final Widget child;

  const RainbowBorder({
    super.key,
    this.borderWidth = 3,
    this.borderRadius = 12,
    this.duration = const Duration(seconds: 3),
    required this.child,
  });

  @override
  State<RainbowBorder> createState() => _RainbowBorderState();
}

class _RainbowBorderState extends State<RainbowBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final angle = _controller.value * 2 * pi;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              transform: GradientRotation(angle),
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
                Colors.red,
              ],
              stops: [0.0, 0.14, 0.28, 0.42, 0.57, 0.71, 0.85, 1.0],
            ),
          ),
          child: Card(
            margin: EdgeInsets.all(widget.borderWidth),
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius - widget.borderWidth,
              ),
            ),
            elevation: 2,
            child: widget.child,
          ),
        );
      },
    );
  }
}
