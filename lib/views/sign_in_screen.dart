import 'package:album_firebase/blocs/auth/auth_bloc.dart';
import 'package:album_firebase/views/code_screen.dart';
import 'package:album_firebase/views/logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error ${state.exception.message}')));
        }
      },
      builder: (context, state) {
        return state is LoggedInState
            ? LoggedInScreen()
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Sign In'),
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          // enabled: !isLoading,
                          controller: _controller,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            }
                          },
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                        SignInEvent(_controller.text.trim()));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CodeScreen()));
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Expanded(
                                            child: Text(
                                          "Sign In",
                                          textAlign: TextAlign.center,
                                        )),
                                      ],
                                    )),
                              ))),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
