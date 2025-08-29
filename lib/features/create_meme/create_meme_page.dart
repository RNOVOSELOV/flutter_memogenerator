import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/features/create_meme/create_meme_bloc.dart';
import 'package:memogenerator/features/create_meme/font_settings_bottom_sheet.dart';
import 'package:memogenerator/features/create_meme/meme_text_on_canvas.dart';
import 'package:memogenerator/features/create_meme/models/meme_text.dart';
import 'package:memogenerator/features/create_meme/models/meme_text_with_offset.dart';
import 'package:memogenerator/features/create_meme/models/meme_text_with_selection.dart';
import 'package:memogenerator/widgets/remove_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import 'models/meme_parameters.dart';

class CreateMemePage extends StatefulWidget {
  final MemeArgs memeArgs;

  const CreateMemePage({super.key, required this.memeArgs});

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
      savedId: widget.memeArgs.id,
      selectedMemePath: widget.memeArgs.path,
      memeRepository: appScopeHolder.scope!.memeRepositoryDep.get,
      memeInteractor: appScopeHolder.scope!.memesInteractorDep.get,
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
          final goBack = await showConfirmationExitDialog(context);
          return goBack ?? false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundAppbar,
            foregroundColor: AppColors.foregroundAppBar,
            title: const Text("Создаем мем"),
            actions: [
              AnimatedIconButton(
                onTap: () => bloc.shareMeme(),
                icon: Icons.share,
              ),
              AnimatedIconButton(
                onTap: () => bloc.saveMeme(),
                icon: Icons.save,
              ),
            ],
            bottom: const _EditTextBar(),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: const SafeArea(child: _CreateMemePageContent()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<bool?> showConfirmationExitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Хотите выйти?"),
          content: const Text("Вы потеряете несохраненные изменения"),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
          actions: [
            AppButton(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              labelText: "Отмена",
              color: AppColors.darkGrey,
            ),
            AppButton(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              labelText: "Выйти",
              color: AppColors.fuchsia,
            ),
          ],
        );
      },
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;

  const AnimatedIconButton({Key? key, required this.onTap, required this.icon})
    : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => scale = 1.5);
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          child: Icon(widget.icon, color: AppColors.darkGrey, size: 24),
          onEnd: () => setState(() => scale = 1.0),
        ),
      ),
    );
  }
}

class _EditTextBar extends StatefulWidget implements PreferredSizeWidget {
  const _EditTextBar({Key? key}) : super(key: key);

  @override
  State<_EditTextBar> createState() => _EditTextBarState();

  @override
  Size get preferredSize => const Size.fromHeight(68);
}

class _EditTextBarState extends State<_EditTextBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: StreamBuilder<MemeText?>(
        stream: bloc.observeSelectedMemeText(),
        builder: (context, snapshot) {
          final MemeText? selectedMemeText = snapshot.hasData
              ? snapshot.data!
              : null;
          if (selectedMemeText?.text != controller.text) {
            final newText = selectedMemeText?.text ?? "";
            controller.text = newText;
            controller.selection = TextSelection.collapsed(
              offset: newText.length,
            );
          }
          final haveSelected = selectedMemeText != null;
          return TextField(
            enabled: haveSelected,
            controller: controller,
            onChanged: (value) {
              if (haveSelected) {
                bloc.changeMemeText(selectedMemeText.id, value);
              }
            },
            onEditingComplete: () => bloc.deselectMemeText(),
            cursorColor: AppColors.fuchsia,
            decoration: InputDecoration(
              hintText: haveSelected ? "Ввести текст" : "",
              hintStyle: TextStyle(fontSize: 16, color: AppColors.darkGrey38),
              filled: true,
              fillColor: haveSelected
                  ? AppColors.fuchsia16
                  : AppColors.darkGrey6,
              border: UnderlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                borderSide: BorderSide(width: 1, color: AppColors.fuchsia38),
              ),
              disabledBorder: UnderlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                borderSide: BorderSide(width: 1, color: AppColors.darkGrey38),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                borderSide: BorderSide(width: 2, color: AppColors.fuchsia),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _CreateMemePageContent extends StatefulWidget {
  const _CreateMemePageContent({Key? key}) : super(key: key);

  @override
  State<_CreateMemePageContent> createState() => _CreateMemePageContentState();
}

class _CreateMemePageContentState extends State<_CreateMemePageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 2, child: MemeCanvasWidget()),
        Container(height: 1, width: double.infinity, color: AppColors.darkGrey),
        const Expanded(flex: 1, child: _BottomList()),
      ],
    );
  }
}

class _BottomList extends StatelessWidget {
  const _BottomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return GestureDetector(
      onTap: () => bloc.deselectMemeText(),
      child: Container(
        color: AppColors.backgroundColor,
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
                      AppButton(
                        onTap: () => bloc.addNewText(),
                        labelText: "Добавить текст",
                        icon: Icons.add,
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
      ),
    );
  }
}

class _BottomSeparator extends StatelessWidget {
  const _BottomSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: AppColors.darkGrey,
    );
  }
}

class BottomMemeText extends StatelessWidget {
  const BottomMemeText({Key? key, required this.item}) : super(key: key);

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
        color: item.selected ? AppColors.darkGrey16 : Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.memeText.text,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            const SizedBox(width: 4),
            BottomMemeTextAction(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
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
              icon: Icons.font_download_outlined,
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

class BottomMemeTextAction extends StatelessWidget {
  const BottomMemeTextAction({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon)),
    );
  }
}

class MemeCanvasWidget extends StatelessWidget {
  const MemeCanvasWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return Container(
      color: AppColors.darkGrey38,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () => bloc.deselectMemeText(),
          child: StreamBuilder<ScreenshotController>(
            stream: bloc.observeScreenShotController(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox.shrink();
              }
              return Screenshot(
                controller: snapshot.requireData,
                child: Stack(children: const [BackgroundImage(), MemeTexts()]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MemeTexts extends StatelessWidget {
  const MemeTexts({Key? key}) : super(key: key);

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

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return StreamBuilder<String?>(
      stream: bloc.observeMemePath(),
      builder: (context, snapshot) {
        final path = snapshot.hasData ? snapshot.data : null;
        if (path == null) {
          return Container(color: AppColors.backgroundColor);
        }
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class DraggableMemeText extends StatefulWidget {
  final MemeTextWithOffset memeTextWithOffset;
  final BoxConstraints parentConstraints;

  const DraggableMemeText({
    Key? key,
    required this.memeTextWithOffset,
    required this.parentConstraints,
  }) : super(key: key);

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
