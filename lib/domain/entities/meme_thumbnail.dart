import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class MemeThumbnail extends Equatable {
  final String memeId;
  final Uint8List? imageBytes;

  const MemeThumbnail({required this.memeId, required this.imageBytes});

  @override
  List<Object?> get props => [memeId, imageBytes.hashCode];
}
