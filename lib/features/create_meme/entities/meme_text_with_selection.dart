import 'package:equatable/equatable.dart';

import 'meme_text.dart';

class MemeTextWithSelection extends Equatable {
  final MemeText memeText;
  final bool selected;

  const MemeTextWithSelection({required this.memeText, required this.selected});

  @override
  List<Object?> get props => [memeText, selected];
}
