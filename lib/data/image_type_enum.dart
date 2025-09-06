enum ImageTypeEnum {
  meme(path: 'memes'),
  template(path: 'templates'),
  thumbnail(path: 'thumbnails');

  const ImageTypeEnum({required this.path});

  final String path;
}
