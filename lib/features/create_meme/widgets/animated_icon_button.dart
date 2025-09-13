import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;

  const AnimatedIconButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => scale = 1.5);
        widget.onTap();
      },
      style: IconButton.styleFrom(padding: EdgeInsets.zero),
      icon: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        child: Icon(widget.icon, size: 24),
        onEnd: () => setState(() => scale = 1.0),
      ),
    );
  }
}