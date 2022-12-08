import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';

class MainBloc {
  Stream<List<Meme>> observeMemes() =>
      MemesRepository.getInstance().observeMemes();

  Future<String?> selectMeme() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xFile?.path;
  }

  void dispose() {}
}
