import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

class MemeTextOnCanvas extends StatelessWidget {
  const MemeTextOnCanvas({
    Key? key,
    required this.parentConstraints,
    required this.padding,
    required this.selected,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  }) : super(key: key);

  final double padding;
  final BoxConstraints parentConstraints;
  final String text;
  final bool selected;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: parentConstraints.maxWidth,
        maxHeight: parentConstraints.maxHeight,
      ),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: selected ? context.color.accentColor : Colors.transparent,
        ),
        color: selected ? context.color.cardBackgroundColor : Colors.transparent,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
