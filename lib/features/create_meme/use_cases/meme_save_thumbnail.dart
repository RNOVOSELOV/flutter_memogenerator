import 'dart:typed_data';

import 'package:memogenerator/domain/repositories/meme_repository.dart';

class MemeSaveThumbnail {
  final MemeRepository _memeRepository;

  MemeSaveThumbnail({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<bool> call({
    required String memeId,
    required Uint8List thumbnailBinaryData,
  }) async => await _memeRepository.saveThumbnail(
    memeId: memeId,
    thumbnailBinaryData: thumbnailBinaryData,
  );
}
