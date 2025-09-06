import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alt_meme_dto.g.dart';

@JsonSerializable()
class AltMemeDto extends Equatable {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'blank')
  final String url;

  factory AltMemeDto.fromJson(final Map<String, dynamic> json) =>
      _$AltMemeDtoFromJson(json);

  const AltMemeDto({
    required this.id,
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toJson() => _$AltMemeDtoToJson(this);

  @override
  List<Object?> get props => [id, name, url,];
}
