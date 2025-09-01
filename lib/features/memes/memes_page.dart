import 'package:flutter/material.dart';
import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/features/create_meme/models/meme_parameters.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
import 'domain/models/meme_thumbnail.dart';
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
      memeRepository: appScopeHolder.scope!.memeRepositoryDep.get,
      templateInteractor: appScopeHolder.scope!.templatesInteractorDep.get,
      memeInteractor: appScopeHolder.scope!.memesInteractorDep.get,
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
      stream: bloc.observeMemes(),
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
                itemBuilder: (context, index) => GridItem(
                  fileId: items.elementAt(index).memeId,
                  fileUri: items.elementAt(index).fullImageUrl,
                  onPress: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    CustomNavigationHelper.instance.router.pushNamed(
                      NavigationPagePath.editMemePage.name,
                      extra: MemeArgs(
                        id: items.elementAt(index).memeId,
                        path: items.elementAt(index).fullImageUrl,
                      ),
                    );
                  },
                  onDelete: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    final removeMemeDialog = await showConfirmationDialog(
                      context,
                      title: 'Удалить мем?',
                      text: 'Выбранный мем будет удален навсегда',
                      actionButtonText: 'Удалить'
                    );
                    if ((removeMemeDialog ?? false) == true) {
                      bloc.deleteMeme(items.elementAt(index).memeId);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
