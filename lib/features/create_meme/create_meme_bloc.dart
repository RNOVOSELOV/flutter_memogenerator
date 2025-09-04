import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:memogenerator/domain/usecases/meme_get.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_get_binary.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/meme.dart';
import '../../domain/entities/position.dart';
import '../../domain/entities/text_with_position.dart';
import 'entities/meme_text.dart';
import 'entities/meme_text_offset.dart';
import 'entities/meme_text_with_offset.dart';
import 'entities/meme_text_with_selection.dart';
import 'use_cases/meme_save_thumbnail.dart';

class CreateMemeBloc {
  final memeTextsSubject = BehaviorSubject<List<MemeText>>.seeded(<MemeText>[]);
  final selectedMemeTextSubject = BehaviorSubject<MemeText?>.seeded(null);
  final memeTextOffsetSubject = BehaviorSubject<List<MemeTextOffset>>.seeded(
    <MemeTextOffset>[],
  );
  final memePathSubject =
      BehaviorSubject<({Uint8List imageBinary, double aspectRatio})?>.seeded(
        null,
      );
  final newMemeTextOffsetSubject = BehaviorSubject<MemeTextOffset?>.seeded(
    null,
  );

  StreamSubscription<MemeTextOffset?>? newMemeTextOffsetSubscription;
  StreamSubscription<bool>? saveMemeSubscription;
  StreamSubscription<Meme?>? existentMemeSubscription;


  final Meme _meme;
  final MemeGetBinary _getBinary;
  final MemeGet _getMeme;
  final MemeSave _saveMeme;
  final MemeSaveThumbnail _saveMemeThumbnail;

  final ScreenshotController _screenshotController;

  CreateMemeBloc({
    required final Meme meme,
    required final MemeGetBinary getBinary,
    required final MemeGet getMeme,
    required final MemeSave saveMeme,
    required final MemeSaveThumbnail saveMemeThumbnail,
  }) : _meme = meme,
       _getBinary = getBinary,
       _getMeme = getMeme,
       _saveMeme = saveMeme,
       _saveMemeThumbnail = saveMemeThumbnail,
       _screenshotController = ScreenshotController() {
    _subscribeToNewMemTextOffset();
    _subscribeToExistentMeme();
  }

  void _subscribeToExistentMeme() {
    existentMemeSubscription = _getMeme(id: _meme.id).asStream().listen(
      (memeData) {
        // Если мема нет в сторе, то берем его из входяжих параметров
        log('MEMEFILENAME: ${memeData?.fileName}');
        final meme = memeData ?? _meme;
        log('MEMEFILENAME: ${meme.fileName}');
        final memeTexts = meme.texts.map((textWithPosition) {
          return MemeText.createFromTextWithPosition(textWithPosition);
        }).toList();
        final memeTextOffset = meme.texts.map((textWithPosition) {
          return MemeTextOffset(
            id: textWithPosition.id,
            offset: Offset(
              textWithPosition.position.left,
              textWithPosition.position.top,
            ),
          );
        }).toList();
        memeTextsSubject.add(memeTexts);
        memeTextOffsetSubject.add(memeTextOffset);

        _getBinary(fileName: meme.fileName).then((value) {
          if (value != null) {
            memePathSubject.add((
              imageBinary: value.imageBinary,
              aspectRatio: value.aspectRatio,
            ));
          }
        });
      },
      onError: (error, stacktrace) =>
          print("Error in existentMemeSubscription: $error, $stacktrace"),
    );
  }

  Future<void> shareMeme() async {
    // TODO remove shareMemeSubscription. Use direct call
    // TODO _screenshotInteractor.shareScreenshoot(_screenshotController)
    final imageBinaryData = await _screenshotController.capture();
    if (imageBinaryData == null) {
      // TODO add loggining
      // _talker.error(
      //   'ScreenshotInteractor: Error get image from screenshot controller',
      // );
      return;
    }
    final currentDt = DateTime.now();
    final XFile captureFile = XFile.fromData(
      imageBinaryData,
      name: 'capture_${DateFormat('yyyy_MM_dd_HH_mm_ss').format(currentDt)}',
      lastModified: currentDt,
      mimeType: 'image/png',
    );
    await SharePlus.instance.share(
      ShareParams(text: 'Мой новый мем!', files: [captureFile]),
    );
  }

  void changeFontSettings(
    final String textId,
    final Color color,
    final double fontSize,
    final FontWeight fontWeight,
  ) {
    final copiedList = [...memeTextsSubject.value];
    final oldMemeText = copiedList.firstWhereOrNull(
      (element) => element.id == textId,
    );
    if (oldMemeText == null) {
      return;
    }
    copiedList.remove(oldMemeText);
    copiedList.add(
      oldMemeText.copyWithChangedFontSettings(color, fontSize, fontWeight),
    );
    memeTextsSubject.add(copiedList);
  }

  List<TextWithPosition> generateTextWithPositionsForMeme() {
    final memeTexts = memeTextsSubject.value;
    final memeTextOffsets = memeTextOffsetSubject.value;
    final textsWithPosition = memeTexts.map((memeText) {
      final memeTextPosition = memeTextOffsets.firstWhereOrNull((
        memeTextOffset,
      ) {
        return memeTextOffset.id == memeText.id;
      });
      final position = Position(
        top: memeTextPosition?.offset.dy ?? 0,
        left: memeTextPosition?.offset.dx ?? 0,
      );
      return TextWithPosition(
        id: memeText.id,
        text: memeText.text,
        position: position,
        fontSize: memeText.fontSize,
        color: memeText.color,
        fontWeight: memeText.fontWeight,
      );
    }).toList();
    return textsWithPosition;
  }

  Future<bool> saveMeme() async {
    final binaryImageData = await screenshotController.capture();
    if (binaryImageData != null) {
      final memeThumbnailSaveResult = await _saveMemeThumbnail(
        memeId: _meme.id,
        thumbnailBinaryData: binaryImageData,
      );
      final memeSaveResult = await _saveMeme(
        meme: _meme.copyWith(texts: generateTextWithPositionsForMeme()),
      );
      return memeThumbnailSaveResult && memeSaveResult;
    }
    return false;
  }

  Future<bool> memeIsSaved() async {
    final savedMeme = await _getMeme(id: _meme.id);
    if (savedMeme == null) {
      return false;
    }
    final savedMemeTexts = savedMeme.texts.map((textWithPosition) {
      return MemeText.createFromTextWithPosition(textWithPosition);
    }).toList();
    final savedMemeTextOffsets = savedMeme.texts.map((textWithPosition) {
      return MemeTextOffset(
        id: textWithPosition.id,
        offset: Offset(
          textWithPosition.position.left,
          textWithPosition.position.top,
        ),
      );
    }).toList();
    return const DeepCollectionEquality.unordered().equals(
          savedMemeTexts,
          memeTextsSubject.value,
        ) &&
        const DeepCollectionEquality.unordered().equals(
          savedMemeTextOffsets,
          memeTextOffsetSubject.value,
        );
  }

  void _subscribeToNewMemTextOffset() {
    newMemeTextOffsetSubscription = newMemeTextOffsetSubject
        .debounceTime(const Duration(milliseconds: 300))
        .listen(
          (newMemeTextOffset) {
            if (newMemeTextOffset != null) {
              _changeMemeTextOffsetInternal(newMemeTextOffset);
            }
          },
          onError: (error, stacktrace) => print(
            "Error in newMemeTextOffsetSubscription: $error, $stacktrace",
          ),
        );
  }

  void changeMemeTextOffset(final String id, final Offset offset) {
    newMemeTextOffsetSubject.add(MemeTextOffset(id: id, offset: offset));
  }

  void _changeMemeTextOffsetInternal(final MemeTextOffset newMemeTextOffset) {
    final copiedMemeTextOffset = [...memeTextOffsetSubject.value];
    final currentMemeTextOffset = copiedMemeTextOffset.firstWhereOrNull(
      (element) => element.id == newMemeTextOffset.id,
    );
    if (currentMemeTextOffset != null) {
      copiedMemeTextOffset.remove(currentMemeTextOffset);
    }
    copiedMemeTextOffset.add(newMemeTextOffset);
    memeTextOffsetSubject.add(copiedMemeTextOffset);
  }

  void deleteMemeText(String id) {
    final currentMemeTexts = [...memeTextsSubject.value];
    currentMemeTexts.removeWhere((element) => element.id == id);
    memeTextsSubject.add(currentMemeTexts);
  }

  void addNewText() {
    final newMemeText = MemeText.create();
    memeTextsSubject.add([...memeTextsSubject.value, newMemeText]);
    selectedMemeTextSubject.add(newMemeText);
  }

  void changeMemeText(final String id, final String text) {
    final copiedList = [...memeTextsSubject.value];
    final index = copiedList.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    final oldMemeText = copiedList[index];
    copiedList.removeAt(index);
    copiedList.insert(index, oldMemeText.copyWithChangedText(text));
    memeTextsSubject.add(copiedList);
  }

  void selectMemeText(final String? id) {
    final foundMemeText = (id == null)
        ? null
        : memeTextsSubject.value.firstWhereOrNull(
            (element) => element.id == id,
          );
    selectedMemeTextSubject.add(foundMemeText);
  }

  void deselectMemeText() {
    selectedMemeTextSubject.add(null);
  }

  Stream<({Uint8List? imageBinary, double aspectRatio})?> observeMemePath() =>
      memePathSubject.distinct();

  Stream<List<MemeText>> observeMemeTexts() => memeTextsSubject.distinct(
    (previous, next) => const ListEquality().equals(previous, next),
  );

  Stream<List<MemeTextWithOffset>> observeMemeTextsWithOffsets() {
    return Rx.combineLatest2<
          List<MemeText>,
          List<MemeTextOffset>,
          List<MemeTextWithOffset>
        >(observeMemeTexts(), memeTextOffsetSubject.distinct(), (
          memeText,
          memeTextOffsets,
        ) {
          return memeText.map((memeText) {
            final memeTextOffset = memeTextOffsets.firstWhereOrNull((element) {
              return element.id == memeText.id;
            });

            return MemeTextWithOffset(
              offset: memeTextOffset?.offset,
              memeText: memeText,
            );
          }).toList();
        })
        .distinct(
          (previous, next) => const ListEquality().equals(previous, next),
        );
  }

  Stream<MemeText?> observeSelectedMemeText() =>
      selectedMemeTextSubject.distinct();

  ScreenshotController get screenshotController => _screenshotController;

  Stream<List<MemeTextWithSelection>> observeMemeTextsWithSelection() {
    return Rx.combineLatest2<
      List<MemeText>,
      MemeText?,
      List<MemeTextWithSelection>
    >(observeMemeTexts(), observeSelectedMemeText(), (
      memeTexts,
      selectedMemeText,
    ) {
      return memeTexts.map((memeText) {
        return MemeTextWithSelection(
          memeText: memeText,
          selected: memeText.id == selectedMemeText?.id,
        );
      }).toList();
    });
  }

  void dispose() {
    memeTextsSubject.close();
    selectedMemeTextSubject.close();
    memeTextOffsetSubject.close();
    newMemeTextOffsetSubject.close();
    memePathSubject.close();
    existentMemeSubscription?.cancel();
    newMemeTextOffsetSubscription?.cancel();
    saveMemeSubscription?.cancel();
  }
}
