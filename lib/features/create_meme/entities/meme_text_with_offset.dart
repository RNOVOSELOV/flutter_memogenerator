import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:memogenerator/features/create_meme/entities/meme_text.dart';

class MemeTextWithOffset extends Equatable {
  final MemeText memeText;
  final Offset? offset;

  const MemeTextWithOffset({required this.memeText, required this.offset});

  @override
  List<Object?> get props => [memeText, offset];
}
