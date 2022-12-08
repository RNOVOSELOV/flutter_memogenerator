import 'dart:ui';
import 'package:equatable/equatable.dart';

class MemeTextWithOffset extends Equatable {
  final String id;
  final String text;
  final Offset? offset;

  MemeTextWithOffset({
    required this.id,
    required this.text,
    required this.offset,
  });

  @override
  List<Object?> get props => [id, text, offset];
}
