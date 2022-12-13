import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:memogenerator/presentation/main/models/memes_with_docs_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc {
  Stream<MemesWithDocsPath> observeMemesWithDocsPath() =>
      Rx.combineLatest2<List<Meme>, Directory, MemesWithDocsPath>(
          MemesRepository.getInstance().observeMemes(),
          getApplicationDocumentsDirectory().asStream(),
          (memes, docDirectory) =>
              MemesWithDocsPath(memes, docDirectory.absolute.path));

  Future<String?> selectMeme() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xFile?.path;
  }

  void dispose() {}
}
