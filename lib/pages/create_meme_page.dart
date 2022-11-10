import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/blocs/create_meme_bloc.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';

class CreateMemePage extends StatefulWidget {
  CreateMemePage({Key? key}) : super(key: key);

  @override
  State<CreateMemePage> createState() => _CreateMemePageState();
}

class _CreateMemePageState extends State<CreateMemePage> {
  late CreateMemeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CreateMemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundAppbar,
          foregroundColor: AppColors.foregroundAppBar,
          title: Text(
            "Создаем мем",
          ),
          bottom: _EditTextBar(),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: _CreateMemePageContent(),
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
            final MemeText? selectedMemeText =
                snapshot.hasData ? snapshot.data! : null;
            if (selectedMemeText?.text != controller.text) {
              final newText = selectedMemeText?.text ?? "";
              controller.text = newText;
              controller.selection =
                  TextSelection.collapsed(offset: newText.length);
            }
            return TextField(
              enabled: selectedMemeText != null,
              controller: controller,
              onChanged: (value) {
                if (selectedMemeText != null) {
                  bloc.changeMemeText(selectedMemeText.id, value);
                }
              },
              onEditingComplete: () => bloc.deselectMemeText(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.darkGrey6,
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _CreateMemePageContent extends StatefulWidget {
  const _CreateMemePageContent({
    Key? key,
  }) : super(key: key);

  @override
  State<_CreateMemePageContent> createState() => _CreateMemePageContentState();
}

class _CreateMemePageContentState extends State<_CreateMemePageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _MemeCanvasWidget(),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: AppColors.darkGrey,
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.backgroundColor,
            child: ListView(
              children: [
                const SizedBox(height: 12),
                const _AddNewMemeTextButton(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _MemeCanvasWidget extends StatelessWidget {
  const _MemeCanvasWidget({
    Key? key,
  }) : super(key: key);

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
          onTap: () => bloc.selectMemeText(null),
          child: Container(
            color: AppColors.backgroundColor,
            child: StreamBuilder<List<MemeText>>(
              initialData: const <MemeText>[],
              stream: bloc.observeMemeTexts(),
              builder: (context, snapshot) {
                final memeTexts =
                    snapshot.hasData ? snapshot.data! : const <MemeText>[];
                return LayoutBuilder(
                  builder: (BuildContext, BoxConstraints constraints) {
                    return Stack(
                      children: memeTexts.map((memeText) {
                        return DraggableMemeText(
                          memeText: memeText,
                          parentConstraints: constraints,
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableMemeText extends StatefulWidget {
  final MemeText memeText;
  final BoxConstraints parentConstraints;

  const DraggableMemeText({
    Key? key,
    required this.memeText,
    required this.parentConstraints,
  }) : super(key: key);

  @override
  State<DraggableMemeText> createState() => _DraggableMemeTextState();
}

class _DraggableMemeTextState extends State<DraggableMemeText> {
  double top = 0;
  double left = 0;
  final double padding = 8;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          setState(() {
            left = calculateLeft(details);
            top = calculateTop(details);
            bloc.selectMemeText(widget.memeText.id);
          });
        },
        child: StreamBuilder<MemeText?>(
          initialData: null,
          stream: bloc.observeSelectedMemeText(),
          builder: (context, snapshot) {
            final selectedTextId = snapshot.hasData ? snapshot.data!.id : "";
            return Container(
              constraints: BoxConstraints(
                maxWidth: widget.parentConstraints.maxWidth,
                maxHeight: widget.parentConstraints.maxHeight,
              ),
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: (selectedTextId == widget.memeText.id)
                      ? AppColors.fuchsia
                      : Colors.transparent,
                ),
                color: (selectedTextId == widget.memeText.id)
                    ? AppColors.darkGrey6
                    : Colors.transparent,
              ),
              child: Text(
                widget.memeText.text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
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

class _AddNewMemeTextButton extends StatelessWidget {
  const _AddNewMemeTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => bloc.addNewText(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                color: AppColors.fuchsia,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Добавить текст".toUpperCase(),
                style: const TextStyle(
                    color: AppColors.fuchsia,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
