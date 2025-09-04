import '../../../domain/entities/meme_thumbnail.dart';
import '../../../domain/repositories/meme_repository.dart';

class MemeThumbnailsGetStream {
  final MemeRepository _memeRepository;

  MemeThumbnailsGetStream({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Stream<List<MemeThumbnail>> call() =>
      _memeRepository.observeMemesThumbnails();
}
