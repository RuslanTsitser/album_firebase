import 'package:album_firebase/blocs/auth/auth_bloc.dart';
import 'package:album_firebase/blocs/library/library_bloc.dart';
import 'package:album_firebase/firebase_options.dart';
import 'package:album_firebase/repositories/auth_repository.dart';
import 'package:album_firebase/views/logged_in_screen.dart';
import 'package:album_firebase/views/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                AuthBloc(_authRepository, _userRepository)),
        BlocProvider(create: (BuildContext context) => LibraryBloc()),
      ],
      child: MaterialApp(
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SignInScreen();
            }
            return LoggedInScreen();
          },
        ),
      ),
    );
  }
}
