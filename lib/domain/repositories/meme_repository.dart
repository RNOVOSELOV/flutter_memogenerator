import 'dart:typed_data';

import '../entities/meme.dart';
import '../entities/meme_thumbnail.dart';

abstract interface class MemeRepository {
  Stream<List<MemeThumbnail>> observeMemesThumbnails();

  Future<String> uploadMemeFile({
    required String fileFullName,
    required Uint8List fileBinaryData,
  });

  Future<bool> deleteMeme({required final String memeId});

  Future<Meme?> getMeme({required final String id});

  void updateMemesThumbnails();
}
