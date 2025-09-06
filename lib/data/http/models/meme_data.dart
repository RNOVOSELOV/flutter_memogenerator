import 'package:equatable/equatable.dart';
import 'package:memogenerator/data/http/dto/alt_meme_dto.dart';

import '../dto/meme_dto.dart';

class MemeApiData extends Equatable {
  final String fileName;
  final String url;
  final String name;

  const MemeApiData({
    required this.fileName,
    required this.url,
    required this.name,
  });

  MemeApiData.fromApi({required MemeDto memeDto})
    : this(
        fileName: '${memeDto.id}_${memeDto.url.split('/').last}',
        url: memeDto.url,
        name: memeDto.name,
      );

  MemeApiData.fromAltApi({required AltMemeDto memeDto})
    : this(
        fileName: '${memeDto.id}_${memeDto.url.split('/').last}',
        url: memeDto.url,
        name: memeDto.name,
      );

  @override
  List<Object?> get props => [fileName, url, name];
}
