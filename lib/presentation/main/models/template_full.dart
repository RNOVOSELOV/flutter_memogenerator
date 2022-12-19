import 'package:equatable/equatable.dart';

class TemplateFull extends Equatable {
  final String id;
  final String fullImagePath;

  TemplateFull({required this.id, required this.fullImagePath});

  @override
  List<Object?> get props => [id, fullImagePath];
}
