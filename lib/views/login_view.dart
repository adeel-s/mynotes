import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
        backgroundColor: appBarColor,
        title: Text('Login')
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
              return Column(
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
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                  print(userCredential);
                  }
                  on FirebaseAuthException catch (e) {
                    
                    if (e.code == 'invalid-credential') {
                      print ('User not found'); //add alert widget on view later
                    }
                    else {
                      print(e.code);
                    }
                  }
                  catch (e) {
                    print('Something bad happened');
                    print(e.runtimeType);
                    print(e);
                  }
              }, child: const Text('Login'),
              ),
            ],
          );
          default:
            return Text('Loading...');
            }
            
          },
        ),
    );
  }
}