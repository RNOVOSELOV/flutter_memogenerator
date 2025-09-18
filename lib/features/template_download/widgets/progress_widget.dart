import 'dart:ui';

import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _BlurryEffect(child: CircularProgressIndicator());
  }
}

class _BlurryEffect extends StatelessWidget {
  final double opacity = 0.1;
  final double blurry = 1.2;
  final Color shade = Colors.grey.shade200;
  final Widget? child;

  _BlurryEffect({this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: shade.withValues(alpha: opacity)),
          child: child,
        ),
      ),
    );
  }
}
