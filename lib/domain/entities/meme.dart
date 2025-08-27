import 'package:equatable/equatable.dart';

import './text_with_position.dart';

class Meme extends Equatable {
  final String id;
  final List<TextWithPosition> texts;
  final String? memePath;

  const Meme({required this.id, required this.texts, this.memePath});

  @override
  List<Object?> get props => [id, texts, memePath];
}
