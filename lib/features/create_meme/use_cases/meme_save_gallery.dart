import 'dart:typed_data';

import 'package:memogenerator/domain/repositories/meme_repository.dart';

class MemeSaveGallery {
  final MemeRepository _memeRepository;

  MemeSaveGallery({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<bool> call({required final Uint8List imageBinary}) async =>
      await _memeRepository.saveImageToGallery(binaryData: imageBinary);
}
