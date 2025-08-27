import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double top;
  final double left;

  const Position({required this.top, required this.left});

  @override
  List<Object?> get props => [top, left];
}
