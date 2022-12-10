import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/data/models/position.dart';
import 'package:memogenerator/data/repositories/memes_repository.dart';
import 'package:memogenerator/domain/interactors/save_meme_interactor.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_offset.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_with_offset.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text_with_selection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class CreateMemeBloc {
  final memeTextsSubject = BehaviorSubject<List<MemeText>>.seeded(<MemeText>[]);
  final selectedMemeTextSubject = BehaviorSubject<MemeText?>.seeded(null);
  final memeTextOffsetSubject =
      BehaviorSubject<List<MemeTextOffset>>.seeded(<MemeTextOffset>[]);
  final memePathSubject = BehaviorSubject<String?>.seeded(null);

  final newMemeTextOffsetSubject =
      BehaviorSubject<MemeTextOffset?>.seeded(null);

  StreamSubscription<MemeTextOffset?>? newMemeTextOffsetSubscription;
  StreamSubscription<bool>? saveMemeSubscription;
  StreamSubscription<Meme?>? existentMemeSubscription;

  final String id;

  CreateMemeBloc({
    final String? savedId,
    final String? selectedMemePath,
  }) : id = savedId ?? const Uuid().v4() {
    print("Create BLoC of meme, id: $id");
    memePathSubject.add(selectedMemePath);
    _subscribeToNewMemTextOffset();
    _subscribeToExistentMeme();
  }

  void _subscribeToExistentMeme() {
    existentMemeSubscription =
        MemesRepository.getInstance().getMeme(id).asStream().listen(
      (meme) {
        if (meme != null) {
          final memeTexts = meme.texts.map((textWithPosition) {
            return MemeText(
                id: textWithPosition.id, text: textWithPosition.text);
          }).toList();
          final memeTextOffset = meme.texts.map((textWithPosition) {
            return MemeTextOffset(
                id: textWithPosition.id,
                offset: Offset(
                  textWithPosition.position.left,
                  textWithPosition.position.top,
                ));
          }).toList();
          memeTextsSubject.add(memeTexts);
          memeTextOffsetSubject.add(memeTextOffset);
          memePathSubject.add(meme.memePath);
        }
      },
      onError: (error, stacktrace) =>
          print("Error in existentMemeSubscription: $error, $stacktrace"),
    );
  }

  void saveMeme() {
    final memeTexts = memeTextsSubject.value;
    final memeTextOffsets = memeTextOffsetSubject.value;
    final textsWithPosition = memeTexts.map((memeText) {
      final memeTextPosition =
          memeTextOffsets.firstWhereOrNull((memeTextOffset) {
        return memeTextOffset.id == memeText.id;
      });
      final position = Position(
          top: memeTextPosition?.offset.dy ?? 0,
          left: memeTextPosition?.offset.dx ?? 0);
      return TextWithPosition(
          id: memeText.id, text: memeText.text, position: position);
    }).toList();
    saveMemeSubscription =
        _saveMemeInternal(textsWithPosition).asStream().listen(
      (saved) {
        print("Meme saved: $saved");
      },
      onError: (error, stacktrace) =>
          print("Error in saveMemeSubscription: $error, $stacktrace"),
    );
  }

  Future<bool> _saveMemeInternal(
    final List<TextWithPosition> memeTextWithPositions,
  ) async {
    return await SaveMemeInteractor.getInstance().saveMeme(
        id: id,
        textWithPositions: memeTextWithPositions,
        imagePath: memePathSubject.value);
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
      onError: (error, stacktrace) =>
          print("Error in newMemeTextOffsetSubscription: $error, $stacktrace"),
    );
  }

  void changeMemeTextOffset(final String id, final Offset offset) {
    newMemeTextOffsetSubject.add(MemeTextOffset(id: id, offset: offset));
  }

  void _changeMemeTextOffsetInternal(final MemeTextOffset newMemeTextOffset) {
    final copiedMemeTextOffset = [...memeTextOffsetSubject.value];
    final currentMemeTextOffset = copiedMemeTextOffset
        .firstWhereOrNull((element) => element.id == newMemeTextOffset.id);
    if (currentMemeTextOffset != null) {
      copiedMemeTextOffset.remove(currentMemeTextOffset);
    }
    copiedMemeTextOffset.add(newMemeTextOffset);
    memeTextOffsetSubject.add(copiedMemeTextOffset);
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
    copiedList.removeAt(index);
    copiedList.insert(index, MemeText(id: id, text: text));
    memeTextsSubject.add(copiedList);
  }

  void selectMemeText(final String? id) {
    final foundMemeText = (id == null)
        ? null
        : memeTextsSubject.value
            .firstWhereOrNull((element) => element.id == id);
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
    return Rx.combineLatest2<List<MemeText>, List<MemeTextOffset>,
            List<MemeTextWithOffset>>(
        observeMemeTexts(), memeTextOffsetSubject.distinct(),
        (memeText, memeTextOffsets) {
      return memeText.map((memeText) {
        final memeTextOffset = memeTextOffsets.firstWhereOrNull((element) {
          return element.id == memeText.id;
        });

        return MemeTextWithOffset(
            id: memeText.id,
            text: memeText.text,
            offset: memeTextOffset?.offset);
      }).toList();
    }).distinct(
        (previous, next) => const ListEquality().equals(previous, next));
  }

  Stream<MemeText?> observeSelectedMemeText() =>
      selectedMemeTextSubject.distinct();

  Stream<List<MemeTextWithSelection>> observeMemeTextsWithSelection() {
    return Rx.combineLatest2<List<MemeText>, MemeText?,
            List<MemeTextWithSelection>>(
        observeMemeTexts(), observeSelectedMemeText(),
        (memeTexts, selectedMemeText) {
      return memeTexts.map((memeText) {
        return MemeTextWithSelection(
            memeText: memeText, selected: memeText.id == selectedMemeText?.id);
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
