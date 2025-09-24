import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

class BottomMemeTextAction extends StatefulWidget {
  const BottomMemeTextAction({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  State<BottomMemeTextAction> createState() => _BottomMemeTextActionState();
}

class _BottomMemeTextActionState extends State<BottomMemeTextAction> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => scale = 1.2);
        Future.delayed(Duration(milliseconds: 200), widget.onTap);
      },
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
      ),
      icon: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        child: Icon(
          widget.icon,
          color: context.color.iconSelectedColor,
          size: 24,
        ),
        onEnd: () => setState(() => scale = 1.0),
      ),
    );
  }
}
