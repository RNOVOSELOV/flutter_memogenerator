import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/features/create_meme/create_meme_page.dart';
import 'package:memogenerator/widgets/remove_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/resources/app_images.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

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
              Text(
                "Мемогенератор",
                style: GoogleFonts.seymourOne(fontSize: 24),
              ),
            ],
          ),
        ),
        floatingActionButton: CreateFab(
          text: 'Мем',
          onTap: () async {
            final selectedMemePath = await bloc.selectMeme();
            if (selectedMemePath == null) {
              // TODO showError
              return;
            }
            // TODO OPEN CREATE MEME PAGE
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) {
            //       return CreateMemePage(selectedMemePath: selectedMemePath);
            //     },
            //   ),
            // );
          },
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(child: MemesGrid()),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MemesGrid extends StatelessWidget {
  const MemesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final MemesBloc bloc = Provider.of<MemesBloc>(context, listen: false);
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
            return GridItem(
              fileId: item.memeId,
              fileUri: item.fullImageUrl,
              onPress: () async {
                await Future.delayed(Duration(milliseconds: 200), () {});
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateMemePage(id: item.memeId),
                  ),
                );
              },
              onDelete: () async {
                await Future.delayed(Duration(milliseconds: 200), () {});
                if (!context.mounted) {
                  return;
                }
                final removeMemeDialog = await showConfirmationRemoveDialog(
                  context,
                  title: 'Удалить мем?',
                  text: 'Выбранный мем будет удален навсегда',
                );
                if ((removeMemeDialog ?? false) == true) {
                  bloc.deleteMeme(item.memeId);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
