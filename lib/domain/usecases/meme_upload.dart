import 'dart:typed_data';

import '../repositories/meme_repository.dart';

class MemeUploadFile {
  final MemeRepository _memeRepository;

  MemeUploadFile({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<String> call({
    required final String fileName,
    required final Uint8List binaryData,
  }) => _memeRepository.uploadMemeFile(
    fileFullName: fileName,
    fileBinaryData: binaryData,
  );
}
