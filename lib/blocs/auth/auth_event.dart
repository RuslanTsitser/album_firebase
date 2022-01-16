part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String number;

  SignInEvent(this.number);
}

class SignOutEvent extends AuthEvent {}

class SubmitCodeEvent extends AuthEvent {
  final String smsCode;

  SubmitCodeEvent(this.smsCode);
}
