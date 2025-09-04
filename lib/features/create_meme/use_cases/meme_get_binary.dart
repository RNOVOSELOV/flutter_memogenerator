import 'dart:typed_data';

import '../../../domain/repositories/meme_repository.dart';

class MemeGetBinary {
  final MemeRepository _memeRepository;

  MemeGetBinary({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<({Uint8List imageBinary, double aspectRatio})?> call({required final String fileName}) async =>
      await _memeRepository.getImageBinaryData(fileName: fileName);
}
