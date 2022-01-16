import 'package:album_firebase/repositories/auth_repository.dart';
import 'package:album_firebase/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthBloc(AuthRepository authRepository, UserRepository userRepository)
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      await _authRepository.login(event.number);

      emit(WaitingForCodeState());
    });

    on<SubmitCodeEvent>((event, emit) async {
      await _authRepository.signIn(event.smsCode);
      await _authRepository.setUser();
      emit(LoggedInState());
    });

    on<SignOutEvent>((event, emit) async {
      await _authRepository.signOut();
      emit(AuthInitial());
    });
  }
}
