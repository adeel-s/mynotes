// import 'dart:developer';
// import 'package:mynotes/constants/routes.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BetterLoginView extends StatefulWidget {
//   const BetterLoginView({super.key});

//   @override
//   State<BetterLoginView> createState() => _BetterLoginViewState();
// }

// class _BetterLoginViewState extends State<BetterLoginView> {
  
//   //use to access text from email/password text fields
//   late final TextEditingController _email;
//   late final TextEditingController _password;
  
//   //not sure what's happening here
//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }

//   //dispose of variables when this page is no longer used
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 50,
//                       child: TextField(
//                         cursorHeight: 15,
//                         controller: _email,
//                         autocorrect: false,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           filled:true,
//                           fillColor:Color.fromARGB(255, 90, 100, 148),
//                           prefixIcon: Icon(Icons.email),
//                           border: OutlineInputBorder(
//                             borderRadius: 
//                               BorderRadius.all(Radius.circular(30)), 
//                             borderSide: 
//                               BorderSide.none),
//                           hintText: 'email',
//                         )
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 50,
//                       child: TextField(
//                               controller: _password,
//                               obscureText: true,
//                               enableSuggestions: false,
//                               autocorrect: false,
//                               decoration: const InputDecoration(filled:true,
//                                 fillColor:Color.fromARGB(255, 90, 100, 148),
//                                 prefixIcon: Icon(Icons.lock),
//                                 border: OutlineInputBorder(
//                                   borderRadius: 
//                                     BorderRadius.all(Radius.circular(30)), 
//                                   borderSide: 
//                                     BorderSide.none),
//                                 hintText: 'password',
//                               )
//                           ),
//                         ),
//                   ), //Add confirm password field, add option to toggle view
//                   TextButton(
//                     onPressed: () async {
//                       final email = _email.text;
//                       final password = _password.text;
//                       try {
//                       final userCredential = 
//                                   await FirebaseAuth.instance.signInWithEmailAndPassword(
//                                     email: email, 
//                                     password: password);
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         notesRoute,
//                        (route) => false,
//                       );
//                       }
//                       on FirebaseAuthException catch (e) {
                        
//                         if (e.code == 'invalid-credential') {
//                           log('User not found'); //add alert widget on view later
//                         }
//                         else {
//                           log(e.code);
//                         }
//                       }
//                       catch (e) {
//                         log('Something bad happened');
//                         log(e.runtimeType.toString());
//                         log(e.toString());
//                       }
//                   }, child: const Text('Login'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         registerRoute,
//                         (route) => false,
//                       );
//                     }, 
//                     child: const Text('Register here'),
//                     )
//                 ],
//               ),
//       ),
//     );
//   }
// }
