import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'memes_data.dart';


part 'memes_response.g.dart';

@JsonSerializable()
class MemesResponse extends Equatable {
  @JsonKey(name: 'success')
  final bool success;
  @JsonKey(name: 'data')
  final MemesData memesData;

  factory MemesResponse.fromJson(final Map<String, dynamic> json) =>
      _$MemesResponseFromJson(json);

  const MemesResponse({required this.success, required this.memesData});

  Map<String, dynamic> toJson() => _$MemesResponseToJson(this);

  @override
  List<Object?> get props => [success, memesData];
}
