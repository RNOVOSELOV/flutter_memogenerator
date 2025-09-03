import 'package:memogenerator/domain/repositories/meme_repository.dart';

import '../../../domain/entities/meme.dart';

class MemeSave {
  final MemeRepository _memeRepository;

  MemeSave({required MemeRepository memeRepository})
    : _memeRepository = memeRepository;

  Future<bool> call({
    required final Meme meme,
  }) async => await _memeRepository.saveMeme(
    meme: meme,
  );
}
