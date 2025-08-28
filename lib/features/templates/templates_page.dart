import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/shared_pref/repositories/memes/memes_repository.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/shared_pref/shared_preference_data.dart';
import 'package:memogenerator/features/easter_egg/easter_egg_page.dart';
import 'package:memogenerator/features/create_meme/create_meme_page.dart';
import 'package:memogenerator/widgets/remove_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../resources/app_images.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
import 'templates_bloc.dart';
import '../memes/domain/models/meme_thumbnail.dart';
import 'domain/models/template_full.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  late TemplatesBloc bloc;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    bloc = TemplatesBloc(
      templatesRepository: appScopeHolder.scope!.templateRepositoryDep.get,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.backgroundAppbar,
          foregroundColor: AppColors.foregroundAppBar,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  AppImages.iconLauncher,
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Text("Шаблоны", style: GoogleFonts.seymourOne(fontSize: 24)),
            ],
          ),
        ),
        floatingActionButton: CreateFab(
          text: 'Шаблон',
          onTap: () async {
            await bloc.addTemplate();
          },
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(child: TemplatesGrid()),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class TemplatesGrid extends StatelessWidget {
  const TemplatesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final TemplatesBloc bloc = Provider.of<TemplatesBloc>(
      context,
      listen: false,
    );
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
            return GridItem(
              fileId: template.id,
              fileUri: template.fullImagePath,
              onPress: () async {
                await Future.delayed(Duration(milliseconds: 200), () {});
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateMemePage(
                      selectedMemePath: template.fullImagePath,
                    ),
                  ),
                );
              },
              onDelete: () async {
                final removeTemplateDialog = await showConfirmationRemoveDialog(
                  context,
                  title: 'Удалить шаблон?',
                  text: 'Выбранный шаблон будет удален навсегда',
                );
                if ((removeTemplateDialog ?? false) == true) {
                  bloc.deleteTemplate(template.id);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
