import 'dart:developer';
import 'package:mynotes/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  )
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'password',
                  )
                ), //Add confirm password field, add option to toggle view
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                    final userCredential = 
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    log(userCredential.toString());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        log(e.code);
                      } else if (e.code == 'email-already-in-use'){
                        log('email already in use');
                      }
                      else if (e.code == 'invalid-email'){
                        log('Invalid email')  ;
                      }
                    }
                }, child: const Text('Register'),
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