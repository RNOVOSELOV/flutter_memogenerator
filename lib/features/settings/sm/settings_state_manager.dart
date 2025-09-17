import 'package:flutter/cupertino.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';
import 'package:memogenerator/domain/repositories/templates_repository.dart';
import 'package:yx_state/yx_state.dart';

import '../../../generated/l10n.dart';
import 'settings_state.dart';

class SettingsStateManager extends StateManager<SettingsState> {
  final TemplatesRepository _templatesRepository;

  SettingsStateManager(
    super.state, {
    required final TemplatesRepository templateRepository,
  }) : _templatesRepository = templateRepository {
    getCacheSize();
  }

  Future<void> getCacheSize() => handle((emit) async {
    final result = await _templatesRepository.getCacheSize();
    emit(SettingsDataState(cacheSize: result));
  });

  String formatBytes(BuildContext context, {required final int bytes}) {
    if (bytes < 1024) return S.of(context).settings_b('$bytes');
    if (bytes < 1024 * 1024) {
      return S.of(context).settings_Kb((bytes / 1024).toStringAsFixed(2));
    }
    if (bytes < 1024 * 1024 * 1024) {
      return S
          .of(context)
          .settings_Mb((bytes / (1024 * 1024)).toStringAsFixed(2));
    }
    return S
        .of(context)
        .settings_Gb((bytes / (1024 * 1024 * 1024)).toStringAsFixed(2));
  }
}
