import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/domain/entities/template.dart';

part 'template_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TemplateModel extends Equatable {
  final String id;
  final String imageUrl;

  factory TemplateModel.fromJson(final Map<String, dynamic> json) =>
      _$TemplateModelFromJson(json);

  const TemplateModel({required this.id, required this.imageUrl});

  Map<String, dynamic> toJson() => _$TemplateModelToJson(this);

  Template get template => Template(id: id, imageUrl: imageUrl);

  factory TemplateModel.fromTemplate({required final Template template}) {
    return TemplateModel(id: template.id, imageUrl: template.imageUrl);
  }

  @override
  List<Object?> get props => [id, imageUrl];
}
