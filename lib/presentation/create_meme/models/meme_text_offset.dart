import 'dart:ui';
import 'package:equatable/equatable.dart';

class MemeTextOffset extends Equatable {
  final String id;
  final Offset offset;

  MemeTextOffset({required this.id, required this.offset});

  @override
  List<Object?> get props => [id, offset];
}
