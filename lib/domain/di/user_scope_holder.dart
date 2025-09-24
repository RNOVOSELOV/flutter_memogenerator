import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/di_sm/auth_scope.dart';
import 'package:memogenerator/domain/usecases/meme_get.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_get_binary.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save_gallery.dart';
import 'package:memogenerator/features/create_meme/use_cases/meme_save_thumbnail.dart';
import 'package:memogenerator/features/templates/sm/templates_bloc.dart';
import 'package:yx_scope/yx_scope.dart';

import '../../di_sm/scope_observer.dart';
import '../../features/memes/sm/memes_bloc.dart';
import '../../features/settings/sm/settings_state_manager.dart';
import 'download_scope_holder.dart';

abstract class UserStateHolder {
  Future<void> toggle();

  MemeGet get getMeme;

  MemeGetBinary get getMemeBinary;

  MemeSave get saveMeme;

  MemeSaveThumbnail get saveMemeThumbnail;

  MemeSaveGallery get saveMemeToGallery;

  MemesSm get memesSm;

  TemplatesSm get templatesSm;

  SettingsStateManager get settingsSm;

  ApiStateHolder get apiStateHolder;
}

class UserScopeHolder
    extends
        BaseChildScopeHolder<
          UserDataScope,
          UserScopeContainer,
          AppScopeContainer
        >
    implements UserStateHolder {
  UserScopeHolder(super.parent)
    : super(
        scopeObservers: [diObserver],
        asyncDepObservers: [diObserver],
        depObservers: [diObserver],
      );

  @override
  UserScopeContainer createContainer(AppScopeContainer parent) =>
      UserScopeContainer(parent: parent);

  @override
  Future<void> toggle() async {
    if (scope == null) {
      await create();
    } else {
      await drop();
    }
  }

  @override
  MemesSm get memesSm => scope!.memesSm;

  @override
  TemplatesSm get templatesSm => scope!.templatesSm;

  @override
  SettingsStateManager get settingsSm => scope!.settingsSm;

  @override
  MemeGet get getMeme => scope!.getMeme;

  @override
  MemeGetBinary get getMemeBinary => scope!.getMemeBinary;

  @override
  MemeSave get saveMeme => scope!.saveMeme;

  @override
  MemeSaveThumbnail get saveMemeThumbnail => scope!.saveMemeThumbnail;

  @override
  MemeSaveGallery get saveMemeToGallery => scope!.saveMemeToGallery;

  @override
  ApiStateHolder get apiStateHolder => scope!.apiStateHolder;
}
