import 'dart:developer';
import 'package:mynotes/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  log(e.code);
                  await showErrorDialog(
                    context,
                    'Password requirements not met',
                  );
                } else if (e.code == 'email-already-in-use') {
                  log('email already in use');
                  await showErrorDialog(
                    context,
                    'Email address taken',
                  );
                } else if (e.code == 'invalid-email') {
                  log('Invalid email');
                  await showErrorDialog(
                    context,
                    'Invalid email format',
                  );
                }
              } catch (e) {
                log('Something bad happened');
                log(e.runtimeType.toString());
                log(e.toString());
                await showErrorDialog(
                  context,
                  'Error: ${e.toString()}',
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
