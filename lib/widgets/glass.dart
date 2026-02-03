import 'dart:ui';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Color tint;
  final Border? border;

  const Glass({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.14,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.padding = const EdgeInsets.all(12),
    this.tint = Colors.black,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint.withOpacity(opacity),
            borderRadius: borderRadius,
            border: border ?? Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: child,
        ),
      ),
    );
  }
}