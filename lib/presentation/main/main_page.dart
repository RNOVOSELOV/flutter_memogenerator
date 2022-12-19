import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:memogenerator/presentation/main/main_bloc.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:memogenerator/presentation/main/models/memes_with_docs_path.dart';
import 'package:memogenerator/presentation/main/models/template_full.dart';
import 'package:memogenerator/presentation/widgets/app_button.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc();
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
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppColors.backgroundAppbar,
              foregroundColor: AppColors.foregroundAppBar,
              title: Text(
                "Мемогенератор",
                style: GoogleFonts.seymourOne(fontSize: 24),
              ),
              bottom: TabBar(
                labelColor: AppColors.darkGrey,
                indicatorColor: AppColors.fuchsia,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    text: "Созданные".toUpperCase(),
                  ),
                  Tab(
                    text: "Шаблоны".toUpperCase(),
                  )
                ],
              ),
            ),
            floatingActionButton: CreateMemeFab(),
            backgroundColor: AppColors.backgroundColor,
            body: TabBarView(
              children: [
                SafeArea(child: CreatedMemesGrid()),
                SafeArea(child: TemplatesGrid()),
              ],
            ),
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
  const CreateMemeFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return FloatingActionButton.extended(
      onPressed: () async {
        final selectedMemePath = await bloc.selectMeme();
        if (selectedMemePath == null) {
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CreateMemePage(
            selectedMemePath: selectedMemePath,
          );
        }));
      },
      icon: const Icon(
        Icons.add,
        color: AppColors.white,
      ),
      backgroundColor: AppColors.fabColor,
      label: const Text(
        "Создать",
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}

class CreatedMemesGrid extends StatelessWidget {
  const CreatedMemesGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MemesWithDocsPath>(
      stream: bloc.observeMemesWithDocsPath(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final items = snapshot.requireData.memes;
        final docsPath = snapshot.requireData.docsPath;
        return GridView.extent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          children: items.map((item) {
            return MemeGridItem(
              docsPath: docsPath,
              memeId: item.id,
            );
          }).toList(),
        );
      },
    );
  }
}

class MemeGridItem extends StatelessWidget {
  const MemeGridItem({
    Key? key,
    required this.docsPath,
    required this.memeId,
  }) : super(key: key);

  final String docsPath;
  final String memeId;

  @override
  Widget build(BuildContext context) {
    final imageFile = File("$docsPath${Platform.pathSeparator}$memeId.png");
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateMemePage(id: memeId),
      )),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGrey, width: 1),
        ),
        child: imageFile.existsSync() ? Image.file(imageFile) : Text(memeId),
      ),
    );
  }
}

class TemplatesGrid extends StatelessWidget {
  const TemplatesGrid({
    Key? key,
  }) : super(key: key);

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
            return TemplateGridItem(
              template: template,
            );
          }).toList(),
        );
      },
    );
  }
}

class TemplateGridItem extends StatelessWidget {
  const TemplateGridItem({
    Key? key,
    required this.template,
  }) : super(key: key);

  final TemplateFull template;

  @override
  Widget build(BuildContext context) {
    final imageFile = File(template.fullImagePath);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CreateMemePage(
            selectedMemePath: template.fullImagePath,
          ),
        ));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGrey, width: 1),
        ),
        child: imageFile.existsSync() ? Image.file(imageFile) : Text(template.id),
      ),
    );
  }
}
