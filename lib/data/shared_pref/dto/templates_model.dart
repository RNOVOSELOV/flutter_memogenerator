import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'template_model.dart';

part 'templates_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TemplatesModel extends Equatable {
  final List<TemplateModel> templates;

  factory TemplatesModel.fromJson(final Map<String, dynamic> json) =>
      _$TemplatesModelFromJson(json);

  const TemplatesModel({required this.templates});

  Map<String, dynamic> toJson() => _$TemplatesModelToJson(this);

  @override
  List<Object?> get props => [templates];
}
