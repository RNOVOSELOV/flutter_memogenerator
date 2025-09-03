import 'dart:typed_data';

import '../entities/meme.dart';
import '../entities/meme_thumbnail.dart';
import '../entities/text_with_position.dart';

abstract interface class MemeRepository {
  Stream<List<MemeThumbnail>> observeMemesThumbnails();

  Future<bool> saveThumbnail({
    required final String memeId,
    required final Uint8List thumbnailBinaryData,
  });

  Future<String> uploadMemeFile({
    required String fileFullName,
    required Uint8List fileBinaryData,
  });

  Future<bool> deleteMeme({required final String memeId});

  Future<Meme?> getMeme({required final String id});

  Future<bool> saveMeme({required final Meme meme});

  Future<({Uint8List imageBinary, double aspectRatio})?> getImageBinaryData({
    required String fileName,
  });

  void updateMemesThumbnails();
}
