import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/data/models/meme_text_with_position.dart';

part 'meme.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Meme extends Equatable {
  final String id;
  final List<MemeTextWithPosition> texts;
  final String? memePath;

  Meme({
    required this.id,
    required this.texts,
    this.memePath,
  });

  factory Meme.fromJson(final Map<String, dynamic> json) =>
      _$MemeFromJson(json);

  Map<String, dynamic> toJson() => _$MemeToJson(this);

  @override
  List<Object?> get props => [id, texts, memePath];
}
