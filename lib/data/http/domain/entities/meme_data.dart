import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../model/meme_dto.dart';

class MemeData extends Equatable {
  final String fileName;
  final double aspectRatio;
  final String url;

  const MemeData({
    required this.fileName,
    required this.aspectRatio,
    required this.url,
  });

  MemeData.fromApi({required MemeDto memeDto})
    : this(
        fileName:
            '${memeDto.id}_${memeDto.url.split(Platform.pathSeparator).last}',
        url: memeDto.url,
        aspectRatio: memeDto.width / memeDto.height,
      );

  @override
  List<Object?> get props => [fileName, aspectRatio, url];
}
