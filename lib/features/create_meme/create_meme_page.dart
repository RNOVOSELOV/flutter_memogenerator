import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/entities/message_status.dart';
import 'package:memogenerator/features/create_meme/sm/create_meme_state.dart';
import 'package:memogenerator/features/create_meme/sm/create_meme_state_manager.dart';
import 'package:memogenerator/features/create_meme/widgets/meme_text_on_canvas.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../domain/entities/meme.dart';
import '../../generated/l10n.dart';
import '../../navigation/navigation_helper.dart';
import '../../widgets/confirmation_dialog.dart';
import 'entities/meme_text_with_offset.dart';
import 'entities/meme_text_with_selection.dart';
import 'widgets/animated_icon_button.dart';
import 'widgets/bottom_meme_text_action.dart';
import 'widgets/font_settings_bottom_sheet.dart';

class CreateMemePage extends StatefulWidget {
  final Meme meme;

  const CreateMemePage({super.key, required this.meme});

  @override
  State<CreateMemePage> createState() => _CreateMemePageState();
}

class _CreateMemePageState extends State<CreateMemePage> {
  late final CreateMemeStateManager manager;

  @override
  void initState() {
    super.initState();
    final userScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    ).scope!.authStateHolderDep.get;
    manager = CreateMemeStateManager(
      CreateMemeInitialState(),
      meme: widget.meme,
      getBinary: userScopeHolder.getMemeBinary,
      getMeme: userScopeHolder.getMeme,
      saveMeme: userScopeHolder.saveMeme,
      saveMemeThumbnail: userScopeHolder.saveMemeThumbnail,
      saveMemeToGallery: userScopeHolder.saveMemeToGallery,
    )..getMemeData();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(value: manager, child: _CreateMemePopWidget());
  }

  @override
  void dispose() {
    manager.close();
    super.dispose();
  }
}

class _CreateMemePopWidget extends StatelessWidget {
  const _CreateMemePopWidget();

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final allSaved = await sm.memeIsSaved();
        if (allSaved && context.mounted) {
          CustomNavigationHelper.instance.router.pop();
          return;
        }
        if (!context.mounted) return;
        final goBack = await showConfirmationDialog(
          context,
          title: S.of(context).exit_action,
          text: S.of(context).exit_action_desc,
          actionButtonText: S.of(context).exit,
        );
        if (goBack == true && context.mounted) {
          CustomNavigationHelper.instance.router.pop();
        }
      },
      child: _CreateMemePageWidget(),
    );
  }
}

class _CreateMemePageWidget extends StatelessWidget {
  const _CreateMemePageWidget();

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).editor),
        actionsPadding: EdgeInsets.zero,
        actions: [
          AnimatedIconButton(
            onTap: () async {
              await sm.deselectMemeText();
              final result = await sm.saveMeme();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final Message message = Message(
                  status: result ? MessageStatus.success : MessageStatus.error,
                  message: result
                      ? S.of(context).save_meme_success
                      : S.of(context).save_meme_error,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  generateSnackBarWidget(context: context, message: message),
                );
              });
            },
            icon: Icons.save,
          ),
          AnimatedIconButton(
            onTap: () async {
              await sm.deselectMemeText();
              await sm.saveImageFile();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generateSnackBarWidget(
                    context: context,
                    message: Message(
                      status: MessageStatus.success,
                      message: 'Успешно сохранено.',
                    ),
                  ),
                );
              }
            },
            icon: Icons.save_alt_outlined,
          ),
          AnimatedIconButton(
            onTap: () {
              sm.deselectMemeText();
              sm.shareMeme();
            },
            icon: Icons.share,
          ),
        ],
      ),
      body: _CreateMemePageContent(),
    );
  }
}

class _CreateMemePageContent extends StatelessWidget {
  const _CreateMemePageContent();

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return StateBuilder<CreateMemeState>(
      stateReadable: sm,
      buildWhen: (previous, current) => current is MemeImageDataState,
      builder: (context, state, child) {
        if (state is MemeImageDataState) {
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: MemeCanvasWidget(
                        aspectRatio: state.aspectRatio,
                        imageBytes: state.imageBinary,
                      ),
                    ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: context.color.cardBorderColor,
                    ),
                    Expanded(flex: 4, child: child ?? SizedBox.shrink()),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MemeCanvasWidget(
                      aspectRatio: state.aspectRatio,
                      imageBytes: state.imageBinary,
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: 1,
                    color: context.color.cardBorderColor,
                  ),
                  Expanded(flex: 1, child: child ?? SizedBox.shrink()),
                ],
              );
            },
          );
        }
        return SizedBox.shrink();
      },
      child: _BottomList(),
    );
  }
}

class MemeCanvasWidget extends StatelessWidget {
  const MemeCanvasWidget({
    super.key,
    required this.aspectRatio,
    required this.imageBytes,
  });

  final double aspectRatio;
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return GestureDetector(
      onTap: () => sm.deselectMemeText(),
      child: Container(
        color: context.color.cardBackgroundColor,
        padding: const EdgeInsets.all(6),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Screenshot(
                    controller: sm.screenshotController,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: Image.memory(imageBytes, fit: BoxFit.contain),
                        ),
                        MemeTexts(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StateBuilder(
              stateReadable: sm,
              buildWhen: (previous, current) => current is MemeTextsState,
              builder: (context, state, child) {
                if (state is MemeTextsState &&
                    state.selectedMemeTextId != null) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: SizedBox(
                        height: 52,
                        child: _EditTextBar(
                          selectedMemeId: state.selectedMemeTextId ?? '',
                          selectedMemeText:
                              state.textsList
                                  .firstWhereOrNull(
                                    (element) =>
                                        element.memeText.id ==
                                        state.selectedMemeTextId,
                                  )
                                  ?.memeText
                                  .text ??
                              '',
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EditTextBar extends StatefulWidget {
  const _EditTextBar({
    required this.selectedMemeText,
    required this.selectedMemeId,
  });

  final String selectedMemeId;
  final String selectedMemeText;

  @override
  State<_EditTextBar> createState() => _EditTextBarState();
}

class _EditTextBarState extends State<_EditTextBar> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '');
    focusNode = FocusNode(canRequestFocus: true);
    configureTextEdit();
  }

  @override
  void didUpdateWidget(covariant _EditTextBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    configureTextEdit();
  }

  void configureTextEdit() {
    if (widget.selectedMemeText != controller.text) {
      controller.text = widget.selectedMemeText;
      controller.selection = TextSelection.collapsed(
        offset: widget.selectedMemeText.length,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedMemeText.isEmpty) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return StateBuilder(
      stateReadable: sm,
      buildWhen: (previous, current) => current is MemeTextsState,
      builder: (context, state, child) {
        if (state is MemeTextsState) {
          return TextField(
            enabled: true,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            controller: controller,
            onChanged: (value) {
              sm.changeMemeText(id: widget.selectedMemeId, text: value);
            },
            onEditingComplete: () => sm.deselectMemeText(),
            cursorColor: context.color.accentColor,
            style: GoogleFonts.roboto(
              color: context.color.textPrimaryColor,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1,
              letterSpacing: 0.4,
            ),
            decoration: InputDecoration(
              hintText: S.of(context).editor_text_hint,
              filled: true,
              fillColor: context.color.accentColor.withValues(alpha: 0.38),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class _BottomList extends StatelessWidget {
  const _BottomList();

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return GestureDetector(
      onTap: () => sm.deselectMemeText(),
      child: StateBuilder(
        stateReadable: sm,
        buildWhen: (previous, current) => current is MemeTextsState,
        builder: (context, state, child) {
          final List<MemeTextWithOffset> textsList = [];
          String? selectedMemeId;
          if (state is MemeTextsState) {
            textsList.addAll(state.textsList);
            selectedMemeId = state.selectedMemeTextId;
          }
          return ListView.separated(
            itemCount: textsList.length + 1,
            separatorBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const SizedBox.shrink();
              }
              return const _BottomSeparator();
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: TextButton(
                        onPressed: () => sm.addNewText(),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: context.color.accentColor),
                            SizedBox(width: 12),
                            Text(
                              S.of(context).editor_add_text.toUpperCase(),
                              style: TextStyle(
                                color: context.color.accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final item = textsList.elementAt(index - 1);
                return BottomMemeText(
                  item: MemeTextWithSelection(
                    memeText: item.memeText,
                    selected: selectedMemeId == null
                        ? false
                        : item.memeText.id == selectedMemeId,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _BottomSeparator extends StatelessWidget {
  const _BottomSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 1,
      color: context.color.cardBorderColor.withValues(alpha: 0.8),
    );
  }
}

class BottomMemeText extends StatelessWidget {
  const BottomMemeText({super.key, required this.item});

  final MemeTextWithSelection item;

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return GestureDetector(
      onTap: () => sm.selectMemeText(id: item.memeText.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        color: item.selected
            ? context.color.cardBackgroundColor
            : Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.memeText.text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: context.color.textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            BottomMemeTextAction(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Provider.value(
                      value: sm,
                      child: FontSettingBottomSheet(memeText: item.memeText),
                    );
                  },
                );
              },
              icon: Icons.format_color_text_outlined,
            ),
            const SizedBox(width: 4),
            BottomMemeTextAction(
              onTap: () => sm.deleteMemeText(memeId: item.memeText.id),
              icon: Icons.delete_forever_outlined,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class MemeTexts extends StatelessWidget {
  const MemeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return StateBuilder<CreateMemeState>(
      stateReadable: sm,
      buildWhen: (previous, current) => current is MemeTextsState,
      builder: (context, state, child) {
        final List<MemeTextWithOffset> textsList = [];
        if (state is MemeTextsState) {
          textsList.addAll(state.textsList);
        }
        return LayoutBuilder(
          builder: (buildContext, BoxConstraints constraints) {
            return Stack(
              children: textsList.map((memeTextWithOffset) {
                return DraggableMemeText(
                  key: ValueKey(memeTextWithOffset.memeText.id),
                  memeTextWithOffset: memeTextWithOffset,
                  parentConstraints: constraints,
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class DraggableMemeText extends StatefulWidget {
  final MemeTextWithOffset memeTextWithOffset;
  final BoxConstraints parentConstraints;

  const DraggableMemeText({
    super.key,
    required this.memeTextWithOffset,
    required this.parentConstraints,
  });

  @override
  State<DraggableMemeText> createState() => _DraggableMemeTextState();
}

class _DraggableMemeTextState extends State<DraggableMemeText> {
  late double top;
  late double left;
  final double padding = 8;

  @override
  void initState() {
    super.initState();
    top =
        widget.memeTextWithOffset.offset?.dy ??
        calculatePercentByPosition(
          widget.parentConstraints.maxHeight / 2 - padding - 15,
          widget.parentConstraints.maxHeight,
        );
    left =
        widget.memeTextWithOffset.offset?.dx ??
        calculatePercentByPosition(
          widget.parentConstraints.maxWidth / 3,
          widget.parentConstraints.maxWidth,
        );
    if (widget.memeTextWithOffset.offset == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
        sm.changeMemeTextOffset(
          id: widget.memeTextWithOffset.memeText.id,
          offset: Offset(left, top),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<CreateMemeStateManager>(context, listen: false);
    return Positioned(
      top: calculatePositionByPercent(top, widget.parentConstraints.maxHeight),
      left: calculatePositionByPercent(left, widget.parentConstraints.maxWidth),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            sm.selectMemeText(id: widget.memeTextWithOffset.memeText.id),
        onPanUpdate: (details) {
          sm.selectMemeText(id: widget.memeTextWithOffset.memeText.id);
          setState(() {
            left = calculateLeft(details);
            top = calculateTop(details);
            sm.changeMemeTextOffset(
              id: widget.memeTextWithOffset.memeText.id,
              offset: Offset(left, top),
            );
          });
        },
        child: StateBuilder(
          stateReadable: sm,
          buildWhen: (previous, current) => current is MemeTextsState,
          builder: (context, state, child) {
            var selected = false;
            if (state is MemeTextsState) {
              selected =
                  widget.memeTextWithOffset.memeText.id ==
                  state.selectedMemeTextId;
            }
            return MemeTextOnCanvas(
              padding: padding,
              selected: selected,
              parentConstraints: widget.parentConstraints,
              text: widget.memeTextWithOffset.memeText.text,
              fontSize: widget.memeTextWithOffset.memeText.fontSize,
              color: widget.memeTextWithOffset.memeText.color,
              fontWeight: widget.memeTextWithOffset.memeText.fontWeight,
            );
          },
        ),
      ),
    );
  }

  double calculateTop(DragUpdateDetails details) {
    double rawTop =
        calculatePositionByPercent(top, widget.parentConstraints.maxHeight) +
        details.delta.dy;
    if (rawTop < 0) {
      return 0;
    }
    final maxTopValue =
        widget.parentConstraints.maxHeight -
        padding * 2 -
        widget.memeTextWithOffset.memeText.fontSize;
    if (rawTop > maxTopValue) {
      rawTop = maxTopValue;
    }
    return calculatePercentByPosition(
      rawTop,
      widget.parentConstraints.maxHeight,
    );
  }

  double calculateLeft(DragUpdateDetails details) {
    double rawLeft =
        calculatePositionByPercent(left, widget.parentConstraints.maxWidth) +
        details.delta.dx;
    if (rawLeft < 0) {
      return 0;
    }
    final maxLeftValue = widget.parentConstraints.maxWidth - padding * 2 - 20;
    if (rawLeft > maxLeftValue) {
      rawLeft = maxLeftValue;
    }
    return calculatePercentByPosition(
      rawLeft,
      widget.parentConstraints.maxWidth,
    );
  }

  double calculatePercentByPosition(double position, double maxValue) {
    return 1 - (maxValue - position) / maxValue;
  }

  double calculatePositionByPercent(double percent, double maxValue) {
    return percent * maxValue;
  }
}
