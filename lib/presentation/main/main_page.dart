import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/sp/repositories/memes/meme_repository.dart';
import 'package:memogenerator/data/sp/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/sp/shared_preference_data.dart';
import 'package:memogenerator/presentation/easter_egg/easter_egg_page.dart';
import 'package:memogenerator/presentation/main/main_bloc.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:memogenerator/presentation/main/models/meme_thumbnail.dart';
import 'package:memogenerator/presentation/main/models/template_full.dart';
import 'package:memogenerator/presentation/widgets/app_button.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late MainBloc bloc;
  late TabController tabController;
  double tabIndex = 0;

  @override
  void initState() {
    super.initState();
    final sp = SharedPreferenceData();
    bloc = MainBloc(
      memeRepository: MemeRepository(memeDataProvider: sp),
      templatesRepository: TemplatesRepository(memeDataProvider: sp),
    );
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    tabController.animation!.addListener(() {
      setState(() {
        tabIndex = tabController.animation!.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: WillPopScope(
        onWillPop: () async {
          final exitFromApplication = await showConfirmationExitDialog(context);
          return exitFromApplication ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.backgroundAppbar,
            foregroundColor: AppColors.foregroundAppBar,
            title: GestureDetector(
              onLongPress: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const EasterEggPage())),
              child: Text(
                "Мемогенератор",
                style: GoogleFonts.seymourOne(fontSize: 24),
              ),
            ),
            bottom: TabBar(
              controller: tabController,
              labelColor: AppColors.darkGrey,
              indicatorColor: AppColors.fuchsia,
              indicatorWeight: 3,
              tabs: [
                Tab(text: "Созданные".toUpperCase()),
                Tab(text: "Шаблоны".toUpperCase()),
              ],
            ),
          ),
          floatingActionButton: tabIndex <= 0.5
              //              ? AnimatedScale(
              ? Transform.scale(
                  scale: 1 - tabIndex / 0.5,
                  //                  duration: Duration(milliseconds: 100),
                  child: const CreateMemeFab(),
                )
              : Transform.scale(
                  scale: (tabIndex - 0.5) / 0.5,
                  //                  duration: Duration(milliseconds: 100),
                  child: const CreateTemplateFab(),
                ),
          backgroundColor: AppColors.backgroundColor,
          body: TabBarView(
            controller: tabController,
            children: const [
              SafeArea(child: CreatedMemesGrid()),
              SafeArea(child: TemplatesGrid()),
            ],
          ),
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
          title: const Text("Точно хотите выйти?"),
          content: const Text("Мемы сами себя не сделают"),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
          actions: [
            AppButton(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              labelText: "Остаться",
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

class CreateMemeFab extends StatelessWidget {
  const CreateMemeFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return FloatingActionButton.extended(
      onPressed: () async {
        final selectedMemePath = await bloc.selectMeme();
        if (selectedMemePath == null) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateMemePage(selectedMemePath: selectedMemePath);
            },
          ),
        );
      },
      icon: const Icon(Icons.add, color: AppColors.white),
      backgroundColor: AppColors.fabColor,
      label: const Text("Мем", style: TextStyle(color: AppColors.white)),
    );
  }
}

class CreateTemplateFab extends StatelessWidget {
  const CreateTemplateFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return FloatingActionButton.extended(
      onPressed: () async {
        await bloc.addTemplate();
      },
      icon: const Icon(Icons.add, color: AppColors.white),
      backgroundColor: AppColors.fabColor,
      label: const Text("Шаблон", style: TextStyle(color: AppColors.white)),
    );
  }
}

class CreatedMemesGrid extends StatelessWidget {
  const CreatedMemesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<List<MemeThumbnail>>(
      stream: bloc.observeMemes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final items = snapshot.requireData;
        return GridView.extent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          children: items.map((item) {
            return MemeGridItem(memeThumbnail: item);
          }).toList(),
        );
      },
    );
  }
}

class MemeGridItem extends StatelessWidget {
  const MemeGridItem({Key? key, required this.memeThumbnail}) : super(key: key);

  final MemeThumbnail memeThumbnail;

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    final imageFile = File(memeThumbnail.fullImageUrl);
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateMemePage(id: memeThumbnail.memeId),
            ),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.darkGrey, width: 1),
            ),
            child: imageFile.existsSync()
                ? Image.file(imageFile)
                : Text(memeThumbnail.memeId),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final removeMemeDialog = await showConfirmationRemoveDialog(
              context,
              title: 'Удалить мем?',
              text: 'Выбранный мем будет удален навсегда',
            );
            if ((removeMemeDialog ?? false) == true) {
              bloc.deleteMeme(memeThumbnail.memeId);
            }
          },
          child: const DeleteItemButton(),
        ),
      ],
    );
  }
}

class DeleteItemButton extends StatelessWidget {
  const DeleteItemButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.darkGrey38,
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.white,
          size: 18,
        ),
      ),
    );
  }
}

class TemplatesGrid extends StatelessWidget {
  const TemplatesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<List<TemplateFull>>(
      stream: bloc.observeTemplates(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final templates = snapshot.requireData;
        return GridView.extent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          children: templates.map((template) {
            return TemplateGridItem(template: template);
          }).toList(),
        );
      },
    );
  }
}

class TemplateGridItem extends StatelessWidget {
  const TemplateGridItem({Key? key, required this.template}) : super(key: key);

  final TemplateFull template;

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    final imageFile = File(template.fullImagePath);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    CreateMemePage(selectedMemePath: template.fullImagePath),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.darkGrey, width: 1),
            ),
            child: imageFile.existsSync()
                ? Image.file(imageFile)
                : Text(template.id),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final removeTemplateDialog = await showConfirmationRemoveDialog(
              context,
              title: 'Удалить шаблон?',
              text: 'Выбранный шаблон будет удален навсегда',
            );
            if ((removeTemplateDialog ?? false) == true) {
              bloc.deleteTemplate(template.id);
            }
          },
          child: const DeleteItemButton(),
        ),
      ],
    );
  }
}

Future<bool?> showConfirmationRemoveDialog(
  BuildContext context, {
  required String title,
  required String text,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
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
            labelText: "Удалить",
            color: AppColors.fuchsia,
          ),
        ],
      );
    },
  );
}
