import 'package:equatable/equatable.dart';
import 'package:memogenerator/features/create_meme/models/meme_text.dart';

class MemeTextWithSelection extends Equatable {
  final MemeText memeText;
  final bool selected;

  MemeTextWithSelection({required this.memeText, required this.selected});

  @override
  List<Object?> get props => [memeText, selected];
}
