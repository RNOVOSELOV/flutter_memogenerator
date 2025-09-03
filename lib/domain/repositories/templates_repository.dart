import 'dart:typed_data';

abstract interface class TemplatesRepository {
  //Stream<List<MemeThumbnail>> observeMemesThumbnails();

  Future<bool> saveTemplate({
    required final Uint8List fileBytes,
    required String fileName,
  });
}
