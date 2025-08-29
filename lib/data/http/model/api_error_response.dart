import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error_response.g.dart';

@JsonSerializable()
class ApiErrorResponse extends Equatable {
  @JsonKey(name: 'success')
  final bool success;
  @JsonKey(name: 'error_message')
  final String userMessage;

  factory ApiErrorResponse.fromJson(final Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  const ApiErrorResponse({required this.success, this.userMessage = ''});

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);

  @override
  List<Object?> get props => [success, userMessage];
}
