import 'package:cached_network_image/cached_network_image.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/features/template_download/template_download_bloc.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../data/http/domain/entities/api_error.dart';
import '../../data/http/domain/entities/meme_data.dart';
import '../../di_sm/app_scope.dart';
import '../../widgets/grid_item.dart';
import 'fullscreen_image_widget.dart';

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
      child: StreamProvider<Message?>(
        create: (BuildContext context) => bloc.messageStream,
        initialData: null,
        child: Consumer<Message?>(
          builder: (BuildContext context, Message? message, Widget? child) {
            if (message != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generateSnackBarWidget(context: context, message: message),
                );
              });
            }
            return child!;
          },
          child: Scaffold(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            body: TemplatesPageBodyContent(),
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
        final isTemplatesDataReceived = snapshot.hasData;
        final data = snapshot.data;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              titleSpacing: 0,
              title: Text('Загрузить шаблон'),
              floating: isTemplatesDataReceived ? true : false,
              pinned: !isTemplatesDataReceived || (data != null && data.isLeft)
                  ? true
                  : false,
            ),
            if (!isTemplatesDataReceived || data == null)
              SliverFillRemaining(
                child: Center(child: const CircularProgressIndicator()),
              ),
            if (data != null && data.isLeft)
              SliverFillRemaining(
                child: Center(child: Text(data.left.description)),
              ),
            if (data != null && data.isRight)
              data.right.isEmpty
                  ? Center(child: Text('Получен пустой список шаблонов'))
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      sliver: SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: data.right.length,
                        itemBuilder: (context, index) => GridItem(
                          memeData: data.right.elementAt(index),
                          onDownload: () {
                            final TemplateDownloadBloc bloc =
                                Provider.of<TemplateDownloadBloc>(
                                  context,
                                  listen: false,
                                );
                            bloc.saveTemplate(
                              memeData: data.right.elementAt(index),
                            );
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
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            useSafeArea: false,
            barrierDismissible: true,
            builder: (context) {
              return FullScreenImagesWidget(
                onEmptyAreaTap: () => Navigator.of(context).pop(),
                imageData: widget.memeData.url,
              );
            },
          ),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: context.color.cardBackgroundColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: context.color.cardBorderColor, width: 1),
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
                    value: progress.progress,
                  ),
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
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
