import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:memogenerator/domain/entities/meme.dart';
import 'package:memogenerator/domain/entities/meme_thumbnail.dart';
import 'package:memogenerator/domain/usecases/meme_upload.dart';
import 'package:memogenerator/features/memes/use_cases/meme_delete.dart';
import 'package:memogenerator/domain/usecases/meme_get.dart';
import 'package:memogenerator/features/memes/use_cases/meme_thumbnails_get_stream.dart';
import 'package:memogenerator/features/memes/use_cases/template_save.dart';

class MemesBloc {
  final MemeThumbnailsGetStream _getMemesThumbnailStream;
  final MemeGet _getMeme;
  final MemeUploadFile _uploadMemeFile;
  final MemeDelete _deleteMeme;
  final TemplateSave _saveTemplate;

  MemesBloc({
    required MemeThumbnailsGetStream getMemeThumbnailsStream,
    required MemeGet getMeme,
    required MemeUploadFile uploadMemeFile,
    required MemeDelete deleteMeme,
    required TemplateSave saveTemplate,
  }) : _getMemesThumbnailStream = getMemeThumbnailsStream,
       _uploadMemeFile = uploadMemeFile,
       _deleteMeme = deleteMeme,
       _getMeme = getMeme,
       _saveTemplate = saveTemplate;

  Stream<List<MemeThumbnail>> observeMemesThumbnails() =>
      _getMemesThumbnailStream();

  Future<String?> selectMeme() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final data = await xFile.readAsBytes();
      final result = await _saveTemplate(fileName: xFile.path, fileBytesData: data);
      if (result) {
        final newFileName = await _uploadMemeFile  (fileName: xFile.path, binaryData: data);
        return newFileName;
      }
    }
    return null;
  }

  Future<Meme?> getMeme({required final String id}) async {
    return await _getMeme(id: id);
  }

  void deleteMeme(final String memeId) {
    _deleteMeme(memeId: memeId).then((value) {
      // TODO show message about result
    });
  }

  void dispose() {}
}
