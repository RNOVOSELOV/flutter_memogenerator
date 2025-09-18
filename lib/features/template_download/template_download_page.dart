import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memogenerator/features/template_download/sm/template_download_state.dart';
import 'package:memogenerator/features/template_download/sm/template_download_state_manager.dart';
import 'package:memogenerator/features/template_download/widgets/progress_widget.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../data/http/models/meme_data.dart';
import '../../di_sm/app_scope.dart';
import '../../generated/l10n.dart';
import '../../resources/app_icons.dart';
import '../../widgets/grid_item.dart';
import 'widgets/fullscreen_image_widget.dart';

class TemplateDownloadPage extends StatefulWidget {
  const TemplateDownloadPage({super.key});

  @override
  State<TemplateDownloadPage> createState() => _TemplateDownloadPageState();
}

class _TemplateDownloadPageState extends State<TemplateDownloadPage> {
  late final TemplateDownloadStateManager manager;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    manager = TemplateDownloadStateManager(
      DownloadProgressState(),
      appScopeContainer: appScopeHolder.scope!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: manager,
      child: StateBuilder(
        stateReadable: manager,
        buildWhen: (previous, current) =>
            previous is DownloadProgressState ||
            current is DownloadProgressState,
        builder: (BuildContext context, state, Widget? child) {
          return Stack(
            children: [
              child ?? SizedBox.shrink(),
              state is DownloadProgressState
                  ? ProgressWidget()
                  : SizedBox.shrink(),
            ],
          );
        },
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: TemplatesPageBodyContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    manager.close();
    super.dispose();
  }
}

class TemplatesPageBodyContent extends StatelessWidget {
  const TemplatesPageBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TemplateDownloadStateManager manager =
        Provider.of<TemplateDownloadStateManager>(context, listen: false);
    return CustomScrollView(
      slivers: [
        StateBuilder<TemplateDownloadState>(
          stateReadable: manager,
          buildWhen: (previous, current) => current is DownloadDataState,
          builder: (context, state, child) {
            final isTemplatesReceived = state is DownloadDataState
                ? true
                : false;
            return SliverAppBar(
              titleSpacing: 0,
              title: Text(S.of(context).template_download),
              floating: isTemplatesReceived,
              pinned: !isTemplatesReceived,
            );
          },
        ),
        StateConsumer<TemplateDownloadState>(
          stateReadable: manager,
          listenWhen: (previous, current) => current is SaveTemplateState,
          listener: (intContext, state) {
            if (state is SaveTemplateState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generateSnackBarWidget(
                    context: context,
                    message: state.message,
                  ),
                );
              });
            }
          },
          buildWhen: (previous, current) =>
              current is! SaveTemplateState &&
              current is! DownloadProgressState,
          builder: (context, state, child) {
            if (state is DownloadErrorState) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _WarningInfoWidget(warningString: state.errorMessage),
              );
            } else if (state is EmptyDataState) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _WarningInfoWidget(
                  warningString: S.of(context).templates_empty,
                ),
              );
            } else if (state is DownloadDataState) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.templatesList.length,
                  itemBuilder: (context, index) => _GridItem(
                    memeData: state.templatesList.elementAt(index),
                    onDownload: () {
                      manager.saveTemplate(
                        memeData: state.templatesList.elementAt(index),
                      );
                    },
                  ),
                ),
              );
            }
            return SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}

class _WarningInfoWidget extends StatelessWidget {
  const _WarningInfoWidget({required this.warningString});

  final String warningString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.iconError,
              width: 150,
              height: 150,
              colorFilter: ColorFilter.mode(
                context.color.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 32),
            Text(
              warningString,
              textAlign: TextAlign.center,
              style: context.theme.memeSemiBold16.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatefulWidget {
  const _GridItem({required this.onDownload, required this.memeData});

  final VoidCallback onDownload;
  final MemeApiData memeData;

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
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
