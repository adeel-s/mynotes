import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

//This class is a wrapper for Firebase User.
@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(
      {required this.isEmailVerified}); //this is a constuctor definition

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
