import '../entities/meme_thumbnail.dart';
import '../repositories/meme_repository.dart';

class MemeThumbnailsUpdateData {
  final MemeRepository _memeRepository;

  MemeThumbnailsUpdateData({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  void call() => _memeRepository.updateMemesThumbnails();
}
