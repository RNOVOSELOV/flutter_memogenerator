import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meme_dto.g.dart';

@JsonSerializable()
class MemeDto extends Equatable {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'width')
  final num width;
  @JsonKey(name: 'height')
  final num height;

  factory MemeDto.fromJson(final Map<String, dynamic> json) =>
      _$MemeDtoFromJson(json);

  const MemeDto({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => _$MemeDtoToJson(this);

  @override
  List<Object?> get props => [id, name, url, width, height];
}
