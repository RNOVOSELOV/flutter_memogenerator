import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/data/filesystem/images_datasource_impl.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/data/repositories/template_repository_impl.dart';
import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/features/memes/domain/use_cases/meme_delete.dart';
import 'package:memogenerator/features/memes/domain/use_cases/meme_thumbnails_get_stream.dart';
import 'package:memogenerator/features/create_meme/models/meme_parameters.dart';
import 'package:memogenerator/features/memes/domain/use_cases/template_save.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
import '../../domain/entities/meme_thumbnail.dart';
import 'memes_bloc.dart';

class MemesPage extends StatefulWidget {
  const MemesPage({super.key});

  @override
  State<MemesPage> createState() => _MemesPageState();
}

class _MemesPageState extends State<MemesPage> {
  late MemesBloc bloc;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    bloc = MemesBloc(
      // TODO change scoupes
      getMemeThumbnailsStream: MemeThumbnailsGetStream(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
      deleteMeme: MemeDelete(
        memeRepository: appScopeHolder.scope!.memeRepositoryImpl.get,
      ),
      saveTemplate: TemplateSave(
        templateRepository: appScopeHolder.scope!.templateRepositoryImpl.get,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        floatingActionButton: CreateFab(
          text: 'Мем',
          onTap: () async {
            final selectedMemePath = await bloc.selectMeme();
            if (selectedMemePath == null) {
              return;
            }
            CustomNavigationHelper.instance.router.pushNamed(
              NavigationPagePath.editMemePage.name,
              extra: MemeArgs(path: selectedMemePath),
            );
          },
        ),
        body: MemePageBodyContent(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MemePageBodyContent extends StatelessWidget {
  const MemePageBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MemesBloc bloc = Provider.of<MemesBloc>(context, listen: false);
    return StreamBuilder<List<MemeThumbnail>>(
      stream: bloc.observeMemesThumbnails(),
      initialData: [],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final items = snapshot.requireData;
        return CustomScrollView(
          slivers: [
            CustomAppBar(title: 'Мемогенератор'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _MemeItem(memeThumbnail: items.elementAt(index)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MemeItem extends StatelessWidget {
  const _MemeItem({required this.memeThumbnail});

  final MemeThumbnail memeThumbnail;

  @override
  Widget build(BuildContext context) {
    return GridItem(
      fileId: memeThumbnail.memeId,
      fileBytes: memeThumbnail.imageBytes,
      fileUri: '',
      onPress: () async {
        await Future.delayed(Duration(milliseconds: 200), () {});
        if (!context.mounted) {
          return;
        }
        CustomNavigationHelper.instance.router.pushNamed(
          NavigationPagePath.editMemePage.name,
          extra: MemeArgs(
            id: memeThumbnail.memeId,
            // TODO FIX
            //path: items.elementAt(index).fullImageUrl,
            path: '',
          ),
        );
      },
      onDelete: () async {
        final MemesBloc bloc = Provider.of<MemesBloc>(context, listen: false);
        await Future.delayed(Duration(milliseconds: 200), () {});
        if (!context.mounted) {
          return;
        }
        final removeMemeDialog = await showConfirmationDialog(
          context,
          title: 'Удалить мем?',
          text: 'Выбранный мем будет удален навсегда',
          actionButtonText: 'Удалить',
        );
        if ((removeMemeDialog ?? false) == true) {
          bloc.deleteMeme(memeThumbnail.memeId);
        }
      },
    );
  }
}
