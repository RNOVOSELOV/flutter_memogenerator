import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:memogenerator/features/create_meme/entities/meme_text_with_offset.dart';


sealed class CreateMemeState extends Equatable {
  const CreateMemeState();

  @override
  List<Object?> get props => [];
}

final class CreateMemeInitialState extends CreateMemeState {
  const CreateMemeInitialState();

  @override
  List<Object> get props => [];
}

final class MemeImageDataState extends CreateMemeState {
  final Uint8List imageBinary;
  final double aspectRatio;

  const MemeImageDataState({
    required this.imageBinary,
    required this.aspectRatio,
  });

  @override
  List<Object> get props => [imageBinary, aspectRatio];
}

final class MemeTextsState extends CreateMemeState {
  final List<MemeTextWithOffset> textsList;
  final String? selectedMemeTextId;

  const MemeTextsState({
    required this.selectedMemeTextId,
    required this.textsList,
  });

  @override
  List<Object?> get props => [selectedMemeTextId, textsList];
}
