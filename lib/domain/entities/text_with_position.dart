import 'dart:ui';
import 'package:equatable/equatable.dart';

import './position.dart';

class TextWithPosition extends Equatable {
  final String id;
  final String text;
  final Position position;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const TextWithPosition({
    required this.id,
    required this.text,
    required this.position,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  List<Object?> get props => [id, text, position, fontSize, color, fontWeight];
}
