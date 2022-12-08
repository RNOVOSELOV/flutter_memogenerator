import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/data/models/position.dart';

part 'meme_text_with_position.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemeTextWithPosition extends Equatable {
  final String id;
  final String text;
  final Position position;

  MemeTextWithPosition(
      {required this.id, required this.text, required this.position});

  factory MemeTextWithPosition.fromJson(final Map<String, dynamic> json) =>
      _$MemeTextWithPositionFromJson(json);

  Map<String, dynamic> toJson() => _$MemeTextWithPositionToJson(this);

  @override
  List<Object?> get props => [id, text, position];
}
