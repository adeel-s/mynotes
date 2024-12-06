import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log(e.code);
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        log('email already in use');
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        log('Invalid email');
        throw InvalidEmailFormatException();
      } else {
        log(e.toString());
        throw GenericAuthException();
      }
    } catch (e) {
      log('Something bad happened');
      log(e.runtimeType.toString());
      log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log(e.code);
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        log('Invalid email');
        throw InvalidEmailFormatException();
      } else {
        log(e.toString());
        throw GenericAuthException();
      }
    } catch (e) {
      log('Something bad happened');
      log(e.runtimeType.toString());
      log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
