import '../../../../domain/entities/meme_thumbnail.dart';
import '../../../../domain/repositories/meme_repository.dart';

class MemeDelete {
  final MemeRepository _memeRepository;

  MemeDelete({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<bool> call({required final String memeId}) =>
      _memeRepository.deleteMeme(memeId: memeId);
}
