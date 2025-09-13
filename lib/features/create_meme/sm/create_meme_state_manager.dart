import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:memogenerator/features/create_meme/entities/meme_text.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yx_state/yx_state.dart';

import '../../../domain/entities/meme.dart';
import '../../../domain/entities/position.dart';
import '../../../domain/entities/text_with_position.dart';
import '../../../domain/usecases/meme_get.dart';
import '../entities/meme_text_offset.dart';
import '../entities/meme_text_with_offset.dart';
import '../use_cases/meme_get_binary.dart';
import '../use_cases/meme_save.dart';
import '../use_cases/meme_save_thumbnail.dart';
import 'create_meme_state.dart';

class CreateMemeStateManager extends StateManager<CreateMemeState> {
  final Meme _meme;
  final MemeGetBinary _getBinary;
  final MemeGet _getMeme;
  final MemeSave _saveMeme;
  final MemeSaveThumbnail _saveMemeThumbnail;

  final ScreenshotController _screenshotController;
  final List<MemeText> _memeTextSubject = [];
  List<MemeTextOffset> _memeTextOffsetSubject = const [];
  String? _selectedMemeTextId;

  CreateMemeStateManager(
    super.state, {
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
       _screenshotController = ScreenshotController();

  ScreenshotController get screenshotController => _screenshotController;

  Future<void> getMemeData() => handle((emit) async {
    final meme = await _getMeme(id: _meme.id) ?? _meme;
    final imageData = await _getBinary(fileName: meme.fileName);
    if (imageData != null) {
      emit(
        MemeImageDataState(
          imageBinary: imageData.imageBinary,
          aspectRatio: imageData.aspectRatio,
        ),
      );
    }

    final memeTexts = meme.texts.map((textWithPosition) {
      return MemeText.createFromTextWithPosition(textWithPosition);
    }).toList();
    _memeTextSubject.addAll(memeTexts);
    final memeTextsOffset = meme.texts.map((textWithPosition) {
      return MemeTextOffset(
        id: textWithPosition.id,
        offset: Offset(
          textWithPosition.position.left,
          textWithPosition.position.top,
        ),
      );
    }).toList();
    _memeTextOffsetSubject = [...memeTextsOffset];
    emitTextOffsets(emit);
  });

  void emitTextOffsets(Emitter<CreateMemeState> emit) {
    final textsWithOffsets = _memeTextSubject.map((memeText) {
      final memeTextOffset = _memeTextOffsetSubject.firstWhereOrNull((element) {
        return element.id == memeText.id;
      });
      return MemeTextWithOffset(
        offset: memeTextOffset?.offset,
        memeText: memeText,
      );
    }).toList();
    emit(
      MemeTextsState(
        textsList: textsWithOffsets,
        selectedMemeTextId: _selectedMemeTextId,
      ),
    );
  }

  Future<void> selectMemeText({required final String id}) =>
      handle((emit) async {
        _selectedMemeTextId = id;
        emitTextOffsets(emit);
      });

  Future<void> deselectMemeText() => handle((emit) async {
    _selectedMemeTextId = null;
    emitTextOffsets(emit);
  });

  Future<void> changeMemeTextOffset({
    required final String id,
    required final Offset offset,
  }) => handle((emit) async {
    final MemeTextOffset newMemeOffset = MemeTextOffset(id: id, offset: offset);
    final copiedMemeTextOffset = [..._memeTextOffsetSubject];
    final currentMemeTextOffset = copiedMemeTextOffset.firstWhereOrNull(
      (element) => element.id == newMemeOffset.id,
    );
    if (currentMemeTextOffset != null) {
      copiedMemeTextOffset.remove(currentMemeTextOffset);
    }
    copiedMemeTextOffset.add(newMemeOffset);
    _memeTextOffsetSubject = [...copiedMemeTextOffset];
    emitTextOffsets(emit);
  });

  Future<void> changeMemeText({
    required final String id,
    required final String text,
  }) => handle((emit) async {
    final copiedList = [..._memeTextSubject];
    final index = copiedList.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    final oldMemeText = copiedList[index];
    copiedList.removeAt(index);
    copiedList.insert(index, oldMemeText.copyWithChangedText(text));
    _memeTextSubject.clear();
    _memeTextSubject.addAll(copiedList);
    emitTextOffsets(emit);
  });

  Future<void> changeFontSettings({
    required final String memeId,
    required final Color color,
    required final double fontSize,
    required final FontWeight fontWeight,
  }) => handle((emit) async {
    final copiedList = [..._memeTextSubject];
    final oldMemeText = copiedList.firstWhereOrNull(
      (element) => element.id == memeId,
    );
    if (oldMemeText == null) {
      return;
    }
    copiedList.remove(oldMemeText);
    copiedList.add(
      oldMemeText.copyWithChangedFontSettings(color, fontSize, fontWeight),
    );
    _memeTextSubject.clear();
    _memeTextSubject.addAll(copiedList);
    emitTextOffsets(emit);
  });

  Future<void> addNewText() => handle((emit) async {
    final newMemeText = MemeText.create();
    _memeTextSubject.add(newMemeText);
    _selectedMemeTextId = newMemeText.id;
    emitTextOffsets(emit);
  });

  Future<void> deleteMemeText({required final String memeId}) =>
      handle((emit) async {
        final currentMemeTexts = [..._memeTextSubject];
        currentMemeTexts.removeWhere((element) => element.id == memeId);
        _memeTextSubject.clear();
        _memeTextSubject.addAll(currentMemeTexts);

        final currentMemeOffsets = [..._memeTextOffsetSubject];
        currentMemeOffsets.removeWhere((element) => element.id == memeId);
        _memeTextOffsetSubject = [...currentMemeOffsets];
        await deselectMemeText();
      });

  Future<void> shareMeme() => handle((emit) async {
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
  });

  Future<bool> memeIsSaved() async {
    final savedMeme = await _getMeme(id: _meme.id);
    if (savedMeme == null && _memeTextSubject.isEmpty) {
      return true;
    }
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
          _memeTextSubject,
        ) &&
        const DeepCollectionEquality.unordered().equals(
          savedMemeTextOffsets,
          _memeTextOffsetSubject,
        );
  }

  Future<bool> saveMeme() async {
    final binaryImageData = await _screenshotController.capture();
    if (binaryImageData != null) {
      final memeThumbnailSaveResult = await _saveMemeThumbnail(
        memeId: _meme.id,
        thumbnailBinaryData: binaryImageData,
      );
      final memeSaveResult = await _saveMeme(
        meme: _meme.copyWith(texts: generateTextWithPositionsForMeme()),
      );
      // TODO emit result messages
      return memeThumbnailSaveResult && memeSaveResult;
    }
    return false;
  }

  List<TextWithPosition> generateTextWithPositionsForMeme() {
    final memeTexts = _memeTextSubject;
    final memeTextOffsets = _memeTextOffsetSubject;
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
}
