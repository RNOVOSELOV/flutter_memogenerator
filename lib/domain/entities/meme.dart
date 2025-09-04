import 'package:equatable/equatable.dart';

import './text_with_position.dart';

class Meme extends Equatable {
  final String id;
  final List<TextWithPosition> texts;
  final String fileName;

  const Meme({required this.id, required this.texts, required this.fileName});

  Meme copyWith({
    String? id,
    List<TextWithPosition>? texts,
    String? fileName,
  }) {
    return Meme(
      id: id ?? this.id,
      texts: texts ?? this.texts,
      fileName: fileName ?? this.fileName,
    );
  }

  @override
  List<Object?> get props => [id, texts, fileName];
}
