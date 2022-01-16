part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoggedInState extends AuthState {}

class WaitingForCodeState extends AuthState {}

class ErrorState extends AuthState {
  final FirebaseAuthException exception;

  ErrorState(this.exception);
}
