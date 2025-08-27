import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/domain/entities/position.dart';

part 'position_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PositionModel extends Equatable {
  final double top;
  final double left;

  const PositionModel({required this.left, required this.top});

  factory PositionModel.fromJson(final Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);

  Position get position => Position(top: top, left: left);

  factory PositionModel.fromPosition({required final Position position}) {
    return PositionModel(left: position.left, top: position.top);
  }

  @override
  List<Object?> get props => [top, left];
}
