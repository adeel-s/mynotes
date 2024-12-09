import 'dart:developer';
import 'package:mynotes/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //use to access text from email/password text fields
  late final TextEditingController _email;
  late final TextEditingController _password;

  //not sure what's happening here
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //dispose of variables when this page is no longer used
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appBarColor = Colors.deepPurple;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'email',
              )),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'password',
              )), //Add confirm password field, add option to toggle view
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                log('User not found'); //add alert widget on view later
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on InvalidEmailFormatException {
                log('Invalid email format');
                await showErrorDialog(
                  context,
                  'Invalid email format',
                );
              } on GenericAuthException {
                log('Other authentication error');
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Register here'),
          )
        ],
      ),
    );
  }
}
