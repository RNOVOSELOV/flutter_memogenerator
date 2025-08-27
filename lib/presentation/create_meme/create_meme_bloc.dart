import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memogenerator/domain/interactors/meme_interactor.dart';
import 'package:memogenerator/domain/interactors/screenshot_interactor.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_offset.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_with_offset.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_with_selection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import '../../data/sp/repositories/memes/meme_repository.dart';
import '../../data/sp/shared_preference_data.dart';
import '../../domain/entities/meme.dart';
import '../../domain/entities/position.dart';
import '../../domain/entities/text_with_position.dart';

class CreateMemeBloc {
  final memeTextsSubject = BehaviorSubject<List<MemeText>>.seeded(<MemeText>[]);
  final selectedMemeTextSubject = BehaviorSubject<MemeText?>.seeded(null);
  final memeTextOffsetSubject = BehaviorSubject<List<MemeTextOffset>>.seeded(
    <MemeTextOffset>[],
  );
  final memePathSubject = BehaviorSubject<String?>.seeded(null);
  final screenshotControllerSubject =
      BehaviorSubject<ScreenshotController>.seeded(ScreenshotController());

  final newMemeTextOffsetSubject = BehaviorSubject<MemeTextOffset?>.seeded(
    null,
  );

  StreamSubscription<MemeTextOffset?>? newMemeTextOffsetSubscription;
  StreamSubscription<bool>? saveMemeSubscription;
  StreamSubscription<Meme?>? existentMemeSubscription;
  StreamSubscription<void>? shareMemeSubscription;

  final String id;
  final memeRepository = MemeRepository(
    memeDataProvider: SharedPreferenceData(),
  );

  CreateMemeBloc({final String? savedId, final String? selectedMemePath})
    : id = savedId ?? const Uuid().v4() {
    memePathSubject.add(selectedMemePath);
    _subscribeToNewMemTextOffset();
    _subscribeToExistentMeme();
  }

  void _subscribeToExistentMeme() {
    existentMemeSubscription = memeRepository
        .getItem()
        .asStream()
        .map(
          (memesModel) =>
              memesModel?.memes.firstWhereOrNull((element) => element.id == id),
        )
        .map((memeModel) => memeModel?.meme)
        .listen(
          (meme) {
            if (meme != null) {
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
              if (meme.memePath != null) {
                getApplicationDocumentsDirectory().then((docsDirectory) {
                  final onlyImageName = meme.memePath!
                      .split(Platform.pathSeparator)
                      .last;
                  final fullImagePath =
                      "${docsDirectory.absolute.path}${Platform.pathSeparator}${SaveMemeInteractor.memesPathName}${Platform.pathSeparator}$onlyImageName";
                  memePathSubject.add(fullImagePath);
                });
              }
            }
          },
          onError: (error, stacktrace) =>
              print("Error in existentMemeSubscription: $error, $stacktrace"),
        );
  }

  void shareMeme() {
    shareMemeSubscription?.cancel();
    shareMemeSubscription = ScreenshotInteractor.getInstance()
        .shareScreenshoot(screenshotControllerSubject.value)
        .asStream()
        .listen(
          (event) {},
          onError: (error, stacktrace) =>
              print("Error in shareMemeSubscription: $error, $stacktrace"),
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

  void saveMeme() {
    // TODO
    final interactor = SaveMemeInteractor(
      memeRepository: MemeRepository(memeDataProvider: SharedPreferenceData()),
    );

    saveMemeSubscription = interactor
        .saveMeme(
          id: id,
          textWithPositions: generateTextWithPositionsForMeme(),
          imagePath: memePathSubject.value,
          screenshotController: screenshotControllerSubject.value,
        )
        .asStream()
        .listen(
          (saved) {
            print("Meme saved: $saved");
          },
          onError: (error, stacktrace) =>
              print("Error in saveMemeSubscription: $error, $stacktrace"),
        );
  }

  Future<bool> memeIsSaved() async {
    final savedMeme = (await memeRepository.getItem())?.memes
        .firstWhereOrNull((element) => element.id == id)
        ?.meme;
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

  Stream<String?> observeMemePath() => memePathSubject.distinct();

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

  Stream<ScreenshotController> observeScreenShotController() =>
      screenshotControllerSubject.distinct();

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
    screenshotControllerSubject.close();

    existentMemeSubscription?.cancel();
    newMemeTextOffsetSubscription?.cancel();
    saveMemeSubscription?.cancel();
    shareMemeSubscription?.cancel();
  }
}
