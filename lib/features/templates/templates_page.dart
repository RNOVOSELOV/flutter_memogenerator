import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../domain/entities/meme.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_status.dart';
import '../../generated/l10n.dart';
import '../../navigation/navigation_helper.dart';
import '../../navigation/navigation_path.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
import '../../widgets/snackbar_widget.dart';
import 'sm/templates_bloc.dart';
import '../../domain/entities/template_full.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  late TemplatesSm sm;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    ).scope!.authStateHolderDep.get;
    sm = appScopeHolder.templatesSm;
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: sm,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        floatingActionButton: CreateFab(
          text: S.of(context).template,
          onTap: () async {
            CustomNavigationHelper.instance.router.pushNamed(
              NavigationPagePath.templateDownloadPage.name,
            );
          },
        ),
        body: TemplatesPageBodyContent(),
      ),
    );
  }

  @override
  void dispose() {
    sm.dispose();
    super.dispose();
  }
}

class TemplatesPageBodyContent extends StatelessWidget {
  const TemplatesPageBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TemplatesSm sm = Provider.of<TemplatesSm>(context, listen: false);
    return StreamBuilder<List<TemplateFull>>(
      stream: sm.observeTemplates(),
      initialData: [],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final items = snapshot.requireData;
        return CustomScrollView(
          slivers: [
            CustomAppBar(title: S.of(context).templates),
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
                  fileId: items.elementAt(index).id,
                  fileBytes: items.elementAt(index).templateImageBytes,
                  onPress: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    final fileName = await sm.uploadTemplateToMeme(
                      templateId: items.elementAt(index).id,
                    );
                    if (fileName != null) {
                      CustomNavigationHelper.instance.router.pushNamed(
                        NavigationPagePath.editMemePage.name,
                        extra: Meme(
                          id: const Uuid().v4(),
                          texts: [],
                          fileName: fileName,
                        ),
                      );
                    }
                  },
                  onDelete: () async {
                    final successString = S.of(context).template_remove_success;
                    final errorString = S.of(context).template_remove_error;
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    final removeTemplateDialog = await showConfirmationDialog(
                      context,
                      title: S.of(context).remove_template,
                      text: S.of(context).remove_meme_desc,
                      actionButtonText: S.of(context).remove,
                    );
                    if ((removeTemplateDialog ?? false) == true) {
                      final result = await sm.deleteTemplate(
                        items.elementAt(index).id,
                      );
                      final message = Message(
                        status: result
                            ? MessageStatus.success
                            : MessageStatus.error,
                        message: result ? successString : errorString,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          generateSnackBarWidget(
                            context: context,
                            message: message,
                          ),
                        );
                      });
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
