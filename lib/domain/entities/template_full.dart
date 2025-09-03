import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class TemplateFull extends Equatable {
  final String id;
  final Uint8List templateImageBytes;

  const TemplateFull({required this.id, required this.templateImageBytes});

  @override
  List<Object?> get props => [id, templateImageBytes];
}
