import '../../../../domain/entities/meme.dart';
import '../../../../domain/repositories/meme_repository.dart';

class MemeGet {
  final MemeRepository _memeRepository;

  MemeGet({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<Meme?> call({required final String id}) async => await _memeRepository.getMeme(id: id);
}
