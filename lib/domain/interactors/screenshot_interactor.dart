import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotInteractor {

  static ScreenshotInteractor? _instance;

  ScreenshotInteractor._internal();

  factory ScreenshotInteractor.getInstance() =>
      _instance ??= ScreenshotInteractor._internal();

  Future<void> shareScreenshoot(final ScreenshotController controller) async {
    final image = await controller.capture();
    if (image == null) {
      print("Error get image from screenshot controller");
      return;
    }

    final temDocs = await getTemporaryDirectory();
    final imageFile = File(
        "${temDocs.absolute.path}${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.png");
    await imageFile.create();
    await imageFile.writeAsBytes(image);
//    await Share.shareFiles([imageFile.path]);
    await Share.shareXFiles([XFile(imageFile.path)]);
  }
}
