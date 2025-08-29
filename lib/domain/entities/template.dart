import 'package:equatable/equatable.dart';

class Template extends Equatable {
  final String id;
  final String imageUrl;

  const Template({required this.id, required this.imageUrl});

  @override
  List<Object?> get props => [id, imageUrl];
}
