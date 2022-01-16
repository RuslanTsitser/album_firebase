import 'package:album_firebase/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeScreen extends StatelessWidget {
  CodeScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Code screen'),
        ),
        body: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    initialValue: null,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: 'SMS code',
                        labelStyle: TextStyle(color: Colors.black)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter SMS code';
                      }
                    },
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 40, bottom: 5),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (state is WaitingForCodeState) {
                                    context
                                        .read<AuthBloc>()
                                        .add(SubmitCodeEvent(
                                          _controller.text.trim(),
                                        ));
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Submit",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))),
              ],
            ),
          )
        ]));
  }
}
