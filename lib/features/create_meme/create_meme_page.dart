import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/domain/usecases/meme_get.dart';
import 'package:memogenerator/features/create_meme/create_meme_bloc.dart';
import 'package:memogenerator/features/create_meme/font_settings_bottom_sheet.dart';
import 'package:memogenerator/features/create_meme/meme_text_on_canvas.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_get_binary.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save_thumbnail.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../domain/entities/meme.dart';
import 'entities/meme_text.dart';
import 'entities/meme_text_with_offset.dart';
import 'entities/meme_text_with_selection.dart';

class CreateMemePage extends StatefulWidget {
  final Meme meme;

  const CreateMemePage({super.key, required this.meme});

  @override
  State<CreateMemePage> createState() => _CreateMemePageState();
}

class _CreateMemePageState extends State<CreateMemePage> {
  late CreateMemeBloc bloc;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    bloc = CreateMemeBloc(
      meme: widget.meme,
      getBinary: MemeGetBinary(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
      getMeme: MemeGet(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
      saveMeme: MemeSave(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
      saveMemeThumbnail: MemeSaveThumbnail(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: WillPopScope(
        onWillPop: () async {
          final allSaved = await bloc.memeIsSaved();
          if (allSaved) {
            return true;
          }
          if (!context.mounted) return true;
          final goBack = await showConfirmationDialog(
            context,
            title: 'Хотите выйти?',
            text: 'Вы потеряете несохраненные изменения',
            actionButtonText: 'Выйти',
          );
          return goBack ?? false;
        },
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            titleSpacing: 0,
            title: Text('Редактор'),
            actions: [
              AnimatedIconButton(
                onTap: () {
                  bloc.deselectMemeText();
                  bloc.saveMeme();
                },
                icon: Icons.save,
              ),
              AnimatedIconButton(
                onTap: () {
                  bloc.deselectMemeText();
                  bloc.shareMeme();
                },
                icon: Icons.share,
              ),
            ],
          ),
          body: _CreateMemePageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;

  const AnimatedIconButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => scale = 1.5);
        widget.onTap();
      },
      style: IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
      icon: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        child: Icon(widget.icon, size: 24),
        onEnd: () => setState(() => scale = 1.0),
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
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return StreamBuilder<MemeText?>(
      stream: bloc.observeSelectedMemeText(),
      builder: (context, snapshot) {
        return TextField(
          enabled: true,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          focusNode: focusNode,
          controller: controller,
          onChanged: (value) {
            bloc.changeMemeText(widget.selectedMemeId, value);
          },
          onEditingComplete: () => bloc.deselectMemeText(),
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
            hintText: 'Введите текст',
            filled: true,
            fillColor: context.color.accentColor.withValues(alpha: 0.38),
          ),
        );
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

class _CreateMemePageContent extends StatefulWidget {
  const _CreateMemePageContent();

  @override
  State<_CreateMemePageContent> createState() => _CreateMemePageContentState();
}

class _CreateMemePageContentState extends State<_CreateMemePageContent> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(
            children: [
              const Expanded(flex: 5, child: MemeCanvasWidget()),
              Container(
                height: 1,
                width: double.infinity,
                color: context.color.cardBorderColor,
              ),
              const Expanded(flex: 4, child: _BottomList()),
            ],
          );
        }
        return Row(
          children: [
            const Expanded(flex: 2, child: MemeCanvasWidget()),
            Container(
              height: double.infinity,
              width: 1,
              color: context.color.cardBorderColor,
            ),
            const Expanded(flex: 1, child: _BottomList()),
          ],
        );
      },
    );
  }
}

class _BottomList extends StatelessWidget {
  const _BottomList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return GestureDetector(
      onTap: () => bloc.deselectMemeText(),
      child: StreamBuilder<List<MemeTextWithSelection>>(
        initialData: const <MemeTextWithSelection>[],
        stream: bloc.observeMemeTextsWithSelection(),
        builder: (context, snapshot) {
          final items = snapshot.hasData
              ? snapshot.data!
              : const <MemeTextWithSelection>[];
          return ListView.separated(
            itemCount: items.length + 1,
            separatorBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const SizedBox.shrink(); //SizedBox(height: 0,);
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
                        onPressed: () => bloc.addNewText(),
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
                              'Добавить текст'.toUpperCase(),
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
                final item = items.elementAt(index - 1);
                return BottomMemeText(item: item);
              }
            },
          );
        },
      ),
    );
  }
}

class _BottomSeparator extends StatelessWidget {
  const _BottomSeparator({super.key});

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
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return GestureDetector(
      onTap: () => bloc.selectMemeText(item.memeText.id),
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
                      value: bloc,
                      child: FontSettingBottomSheet(memeText: item.memeText),
                    );
                  },
                );
              },
              icon: Icons.format_color_text_outlined,
            ),
            const SizedBox(width: 4),
            BottomMemeTextAction(
              onTap: () {
                bloc.deleteMemeText(item.memeText.id);
              },
              icon: Icons.delete_forever_outlined,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class BottomMemeTextAction extends StatefulWidget {
  const BottomMemeTextAction({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  State<BottomMemeTextAction> createState() => _BottomMemeTextActionState();
}

class _BottomMemeTextActionState extends State<BottomMemeTextAction> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => scale = 1.2);
        Future.delayed(Duration(milliseconds: 200), widget.onTap);
      },
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
      ),
      icon: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        child: Icon(
          widget.icon,
          color: context.color.iconSelectedColor,
          size: 24,
        ),
        onEnd: () => setState(() => scale = 1.0),
      ),
    );
  }
}

class MemeCanvasWidget extends StatelessWidget {
  const MemeCanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return GestureDetector(
      onTap: () => bloc.deselectMemeText(),
      child: Container(
        color: context.color.cardBackgroundColor,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child:
                  StreamBuilder<
                    ({Uint8List? imageBinary, double aspectRatio})?
                  >(
                    stream: bloc.observeMemePath(),
                    builder: (context, snapshot) {
                      final imageData = snapshot.hasData ? snapshot.data : null;
                      if (imageData == null) {
                        return SizedBox.shrink();
                      }
                      return Center(
                        child: AspectRatio(
                          aspectRatio: imageData.aspectRatio,
                          child: Screenshot(
                            controller: bloc.screenshotController,
                            child: Stack(
                              children: [
                                SizedBox.expand(
                                  child: Image.memory(
                                    imageData.imageBinary!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                MemeTexts(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
            StreamBuilder<MemeText?>(
              stream: bloc.observeSelectedMemeText(),
              builder:
                  (BuildContext context, AsyncSnapshot<MemeText?> snapshot) {
                    final MemeText? selectedMemeText = snapshot.hasData
                        ? snapshot.requireData
                        : null;
                    if (selectedMemeText == null) return SizedBox.shrink();
                    return Align(
                      alignment: Alignment.topCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: SizedBox(
                          height: 52,
                          child: _EditTextBar(
                            selectedMemeId: selectedMemeText.id,
                            selectedMemeText: selectedMemeText.text,
                          ),
                        ),
                      ),
                    );
                  },
            ),
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
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return StreamBuilder<List<MemeTextWithOffset>>(
      initialData: const <MemeTextWithOffset>[],
      stream: bloc.observeMemeTextsWithOffsets(),
      builder: (context, snapshot) {
        final memeTextsWithOffsets = snapshot.hasData
            ? snapshot.data!
            : const <MemeTextWithOffset>[];
        return LayoutBuilder(
          builder: (buildContext, BoxConstraints constraints) {
            return Stack(
              children: memeTextsWithOffsets.map((memeTextWithOffset) {
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
        widget.parentConstraints.maxHeight / 2 - padding - 15;
    left =
        widget.memeTextWithOffset.offset?.dx ??
        widget.parentConstraints.maxWidth / 3;
    if (widget.memeTextWithOffset.offset == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
        bloc.changeMemeTextOffset(
          widget.memeTextWithOffset.memeText.id,
          Offset(left, top),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => bloc.selectMemeText(widget.memeTextWithOffset.memeText.id),
        onPanUpdate: (details) {
          bloc.selectMemeText(widget.memeTextWithOffset.memeText.id);
          setState(() {
            left = calculateLeft(details);
            top = calculateTop(details);
            bloc.changeMemeTextOffset(
              widget.memeTextWithOffset.memeText.id,
              Offset(left, top),
            );
          });
        },
        child: StreamBuilder<MemeText?>(
          initialData: null,
          stream: bloc.observeSelectedMemeText(),
          builder: (context, snapshot) {
            final selectedItem = snapshot.hasData ? snapshot.data : null;
            final selected =
                widget.memeTextWithOffset.memeText.id == selectedItem?.id;
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
    final rawTop = top + details.delta.dy;
    if (rawTop < 0) {
      return 0;
    }
    if (rawTop > widget.parentConstraints.maxHeight - padding * 2 - 30) {
      return widget.parentConstraints.maxHeight - padding * 2 - 30;
    }
    return rawTop;
  }

  double calculateLeft(DragUpdateDetails details) {
    final rawLeft = left + details.delta.dx;
    if (rawLeft < 0) {
      return 0;
    }
    if (rawLeft > widget.parentConstraints.maxWidth - padding * 2 - 10) {
      return widget.parentConstraints.maxWidth - padding * 2 - 10;
    }
    return rawLeft;
  }
}
