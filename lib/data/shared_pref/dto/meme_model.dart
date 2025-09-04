import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/domain/entities/meme.dart';

import 'text_with_position_model.dart';

part 'meme_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemeModel extends Equatable {
  final String id;
  final List<TextWithPositionModel> texts;
  final String memePath;

  const MemeModel({
    required this.id,
    required this.texts,
    required this.memePath,
  });

  factory MemeModel.fromJson(final Map<String, dynamic> json) =>
      _$MemeModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemeModelToJson(this);

  Meme get meme => Meme(
    id: id,
    texts: texts.map((text) => text.textWithPosition).toList(),
    fileName: memePath,
  );

  factory MemeModel.fromMeme({required final Meme meme}) {
    return MemeModel(
      id: meme.id,
      texts: meme.texts
          .map((text) => TextWithPositionModel.fromTemplate(data: text))
          .toList(),
      memePath: meme.fileName,
    );
  }

  @override
  List<Object?> get props => [id, texts, memePath];
}
