import 'package:equatable/equatable.dart';

import '../dto/meme_dto.dart';

class MemeApiData extends Equatable {
  final String fileName;
  final double aspectRatio;
  final String url;
  final String name;

  const MemeApiData({
    required this.fileName,
    required this.aspectRatio,
    required this.url,
    required this.name,
  });

  MemeApiData.fromApi({required MemeDto memeDto})
    : this(
        fileName: '${memeDto.id}_${memeDto.url.split('/').last}',
        url: memeDto.url,
        aspectRatio: memeDto.width / memeDto.height,
        name: memeDto.name,
      );

  @override
  List<Object?> get props => [fileName, aspectRatio, url, name];
}
