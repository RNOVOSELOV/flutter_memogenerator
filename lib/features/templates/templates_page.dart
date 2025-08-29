import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/features/create_meme/create_meme_page.dart';
import 'package:memogenerator/widgets/remove_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../resources/app_images.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/fab_widget.dart';
import '../../widgets/grid_item.dart';
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
      templatesRepository: appScopeHolder.scope!.templateRepositoryDep.get,
      templateInteractor: appScopeHolder.scope!.templatesInteractorDep.get,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        floatingActionButton: CreateFab(
          text: 'Шаблон',
          onTap: () async {
            await bloc.addTemplate();
          },
        ),
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
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => CreateMemePage(
                    //       selectedMemePath: items
                    //           .elementAt(index)
                    //           .fullImagePath,
                    //     ),
                    //   ),
                    // );
                  },
                  onDelete: () async {
                    final removeTemplateDialog =
                        await showConfirmationRemoveDialog(
                          context,
                          title: 'Удалить шаблон?',
                          text: 'Выбранный шаблон будет удален навсегда',
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
