import 'package:equatable/equatable.dart';

class Template extends Equatable {
  final String id;
  final String imageName;

  const Template({required this.id, required this.imageName});

  @override
  List<Object?> get props => [id, imageName];
}
