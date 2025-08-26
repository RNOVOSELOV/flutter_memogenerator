import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'template.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Template extends Equatable {
  final String id;
  final String imageUrl;

  factory Template.fromJson(final Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  const Template({required this.id, required this.imageUrl});

  Map<String, dynamic> toJson() => _$TemplateToJson(this);

  @override
  List<Object?> get props => [id, imageUrl];
}
