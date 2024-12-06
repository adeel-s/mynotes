import 'dart:developer';
import 'package:mynotes/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'package:mynotes/views/verify_email_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on WeakPasswordException {
                await showErrorDialog(
                  context,
                  'Password requirements not met',
                );
              } on EmailAlreadyInUseException {
                await showErrorDialog(
                  context,
                  'Email address taken',
                );
              } on InvalidEmailFormatException {
                await showErrorDialog(
                  context,
                  'Invalid email format',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Registration Error',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Login here'),
          ),
        ],
      ),
    );
  }
}
