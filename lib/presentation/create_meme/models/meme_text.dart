import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class MemeText extends Equatable {
  final String id;
  final String text;

  MemeText({required this.id, required this.text});

  factory MemeText.create() {
    return MemeText(id: const Uuid().v4(), text: "");
  }

  @override
  List<Object?> get props => [id, text];
}