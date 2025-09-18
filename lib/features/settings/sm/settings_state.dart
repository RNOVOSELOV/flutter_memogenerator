import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitialState extends SettingsState {
  const SettingsInitialState();

  @override
  List<Object?> get props => [];
}

class SettingsDataState extends SettingsState {
  final int cacheSize;

  const SettingsDataState({required this.cacheSize});

  @override
  List<Object?> get props => [cacheSize];
}
