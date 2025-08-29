import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/features/template_download/template_download_bloc.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../data/http/domain/entities/api_error.dart';
import '../../data/http/domain/entities/meme_data.dart';
import '../../di_sm/app_scope.dart';
import '../../widgets/grid_item.dart';

class TemplateDownloadPage extends StatefulWidget {
  const TemplateDownloadPage({super.key});

  @override
  State<TemplateDownloadPage> createState() => _TemplateDownloadPageState();
}

class _TemplateDownloadPageState extends State<TemplateDownloadPage> {
  late TemplateDownloadBloc bloc;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    bloc = TemplateDownloadBloc(
      templatesRepository: appScopeHolder.scope!.templateRepositoryDep.get,
      templateInteractor: appScopeHolder.scope!.templatesInteractorDep.get,
      apiRepository: appScopeHolder.scope!.memeApiRepositoryDep.get,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: TemplatesPageBodyContent(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class TemplatesPageBodyContent extends StatelessWidget {
  const TemplatesPageBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TemplateDownloadBloc bloc = Provider.of<TemplateDownloadBloc>(
      context,
      listen: false,
    );
    return FutureBuilder<Either<ApiError, List<MemeData>>>(
      future: bloc.getMemes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: const CircularProgressIndicator(color: AppColors.fuchsia),
          );
        }
        final data = snapshot.requireData;
        if (data.isLeft) {
          // TODO show Error
          return Center(child: Text(data.left.description));
        }
        final items = data.right;
        if (items.isEmpty) {
          // TODO show message
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 3,
              centerTitle: false,
              backgroundColor: AppColors.backgroundAppbar,
              foregroundColor: AppColors.foregroundAppBar,
              titleSpacing: 0,
              title: Text(
                'Загрузить шаблон',
                style: GoogleFonts.seymourOne(fontSize: 24),
              ),
              floating: true,
            ),
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
                  memeData: items.elementAt(index),
                  onDownload: () {
                    final TemplateDownloadBloc bloc =
                        Provider.of<TemplateDownloadBloc>(
                          context,
                          listen: false,
                        );
                    bloc.saveTemplate(memeData: items.elementAt(index));
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

class GridItem extends StatefulWidget {
  const GridItem({super.key, required this.onDownload, required this.memeData});

  final VoidCallback onDownload;
  final MemeData memeData;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.darkGrey16, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.memeData.url,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.fuchsia),
                  value: progress.progress,
                ),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: GridItemActionButton(
            onPress: widget.onDownload,
            icon: Icons.arrow_downward_outlined,
          ),
        ),
      ],
    );
  }
}
