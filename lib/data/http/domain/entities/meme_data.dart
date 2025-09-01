import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../model/meme_dto.dart';

class MemeData extends Equatable {
  final String fileName;
  final double aspectRatio;
  final String url;
  final String name;

  const MemeData({
    required this.fileName,
    required this.aspectRatio,
    required this.url,
    required this.name,
  });

  MemeData.fromApi({required MemeDto memeDto})
    : this(
        fileName:
            '${memeDto.id}_${memeDto.url.split(Platform.pathSeparator).last}',
        url: memeDto.url,
        aspectRatio: memeDto.width / memeDto.height,
        name: memeDto.name,
      );

  @override
  List<Object?> get props => [fileName, aspectRatio, url, name];
}
