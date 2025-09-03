import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../navigation/navigation_helper.dart';
import '../../navigation/navigation_path.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
import '../create_meme/models/meme_parameters.dart';
import 'templates_bloc.dart';
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
      templatesRepository: appScopeHolder.scope!.templateDatasourceDep.get,
      templateInteractor: appScopeHolder.scope!.templatesInteractorDep.get,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        floatingActionButton: CreateFab(
          text: 'Шаблон',
          onTap: () async {
            CustomNavigationHelper.instance.router.pushNamed(
              NavigationPagePath.templateDownloadPage.name,
            );
            //            await bloc.addTemplate();
          },
        ),
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
    final TemplatesBloc bloc = Provider.of<TemplatesBloc>(
      context,
      listen: false,
    );
    return StreamBuilder<List<TemplateFull>>(
      stream: bloc.observeTemplates(),
      initialData: [],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final items = snapshot.requireData;
        return CustomScrollView(
          slivers: [
            CustomAppBar(title: 'Шаблоны'),
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
                  fileUri: items.elementAt(index).fullImagePath,
                  onPress: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    CustomNavigationHelper.instance.router.pushNamed(
                      NavigationPagePath.editMemePage.name,
                      extra: MemeArgs(
                        id: items.elementAt(index).id,
                        path: items.elementAt(index).fullImagePath,
                      ),
                    );
                  },
                  onDelete: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (!context.mounted) {
                      return;
                    }
                    final removeTemplateDialog =
                        await showConfirmationDialog(
                          context,
                          title: 'Удалить шаблон?',
                          text: 'Выбранный шаблон будет удален навсегда',
                          actionButtonText: 'Удалить'
                        );
                    if ((removeTemplateDialog ?? false) == true) {
                      bloc.deleteTemplate(items.elementAt(index).id);
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
