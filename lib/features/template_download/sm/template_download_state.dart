import 'package:equatable/equatable.dart';
import 'package:memogenerator/domain/entities/message.dart';

import '../../../data/http/models/meme_data.dart';

sealed class TemplateDownloadState extends Equatable {
  const TemplateDownloadState();

  @override
  List<Object?> get props => [];
}

final class DownloadProgressState extends TemplateDownloadState {
  const DownloadProgressState();

  @override
  List<Object> get props => [];
}

final class DownloadErrorState extends TemplateDownloadState {
  final String errorMessage;

  const DownloadErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class EmptyDataState extends TemplateDownloadState {
  const EmptyDataState();

  @override
  List<Object> get props => [];
}

final class DownloadDataState extends TemplateDownloadState {
  final List<MemeApiData> templatesList;

  const DownloadDataState({required this.templatesList});

  @override
  List<Object> get props => [templatesList];
}

final class SaveTemplateState extends TemplateDownloadState {
  final Message message;

  const SaveTemplateState({required this.message});

  @override
  List<Object> get props => [message];
}
