import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitialState extends AuthState {
  const AuthInitialState();

  @override
  List<Object> get props => [];
}

final class OpenApplicationState extends AuthState {
  const OpenApplicationState();

  @override
  List<Object> get props => [];
}

final class AuthFailedState extends AuthState {
  const AuthFailedState();

  @override
  List<Object> get props => [];
}
