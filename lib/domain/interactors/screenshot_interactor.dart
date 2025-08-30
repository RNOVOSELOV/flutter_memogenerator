import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talker/talker.dart';

class ScreenshotInteractor {
  final Talker _talker;

  const ScreenshotInteractor({required Talker talker}) : _talker = talker;

  Future<void> shareScreenshoot(final ScreenshotController controller) async {
    final image = await controller.capture();
    if (image == null) {
      _talker.error(
        'ScreenshotInteractor: Error get image from screenshot controller',
      );
      return;
    }

    final temDocs = await getTemporaryDirectory();
    final imageFile = File(
      "${temDocs.absolute.path}${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.png",
    );
    await imageFile.create();
    await imageFile.writeAsBytes(image);
    await SharePlus.instance.share(
      ShareParams(text: 'Мой новый мем!', files: [XFile(imageFile.path)]),
    );
  }

  Future<void> saveThumbnail(
    final String memeId,
    final ScreenshotController controller,
  ) async {
    final image = await controller.capture();
    if (image == null) {
      _talker.error(
        'ScreenshotInteractor: Error share thumbnail. Cann\'t get image from screenshot controller',
      );
      return;
    }
    final docDocs = await getApplicationDocumentsDirectory();
    final imageFile = File(
      "${docDocs.absolute.path}${Platform.pathSeparator}$memeId.png",
    );
    await imageFile.create();
    await imageFile.writeAsBytes(image);
  }
}
