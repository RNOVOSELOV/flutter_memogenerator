import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'meme_model.dart';

part 'memes_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemesModel extends Equatable {
  final List<MemeModel> memes;

  const MemesModel({required this.memes});

  factory MemesModel.fromJson(final Map<String, dynamic> json) =>
      _$MemesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemesModelToJson(this);

  @override
  List<Object?> get props => [memes];
}
