import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'meme_dto.dart';

part 'memes_data.g.dart';

@JsonSerializable()
class MemesData extends Equatable {
  @JsonKey(name: 'memes')
  final List<MemeDto> memes;

  factory MemesData.fromJson(final Map<String, dynamic> json) =>
      _$MemesDataFromJson(json);

  const MemesData({this.memes = const []});

  Map<String, dynamic> toJson() => _$MemesDataToJson(this);

  @override
  List<Object?> get props => [memes];
}
