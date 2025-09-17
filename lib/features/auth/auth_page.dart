import 'package:flutter/material.dart';
import 'package:memogenerator/features/auth/sm/auth_state.dart';
import 'package:memogenerator/features/auth/sm/auth_state_manager.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../generated/l10n.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthStateManager _manager;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    _manager = appScopeHolder.scope!.authScopeModule.authStateManager.get..launchAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _manager,
      child: StateListener(
        stateReadable: _manager,
        listenWhen: (previous, current) => current is OpenApplicationState,
        listener: (context, state) {
          if (state is OpenApplicationState) {
            CustomNavigationHelper.instance.router.pushReplacement(
              NavigationPagePath.memesPage.path,
            );
          }
        },
        child: Scaffold(
          backgroundColor: context.theme.primaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(flex: 5, child: SizedBox.expand()),
                StateBuilder(
                  stateReadable: _manager,
                  buildWhen: (previous, current) => current is AuthFailedState,
                  builder: (context, state, child) {
                    if (state is AuthFailedState) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async => await _manager.repeatAuth(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: context.color.accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            S.of(context).auth,
                            style: context.theme.memeSemiBold24.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                Expanded(flex: 3, child: SizedBox.expand()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> showYesNoDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Разрешить вход в приложение по биометрии?'),
      content: const Text(
        'В дальнейшем вы можете изменить своё решение в настройках приложения.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Нет',
            style: TextStyle(color: context.theme.primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Да',
            style: TextStyle(color: context.theme.primaryColor),
          ),
        ),
      ],
    ),
  );
  return result;
}
