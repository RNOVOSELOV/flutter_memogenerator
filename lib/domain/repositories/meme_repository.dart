import '../entities/meme_thumbnail.dart';

abstract interface class MemeRepository {
  Stream<List<MemeThumbnail>> observeMemesThumbnails();
  Future<bool> deleteMeme ({required final String memeId});
  void updateMemesThumbnails ();
}
