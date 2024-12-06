import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Provider should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    //could add a lot more of these type of tests vvv
    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut,
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Initialize', () async {
      await provider.initialize();
      expect(
        provider.isInitialized,
        true,
      );
    });
    test('User should be null after provider initialization', () {
      expect(
        provider.currentUser,
        null,
      );
    });
    test('Cannot lot out if not initialized', () {
      expect(
        provider.logOut,
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    //This functionality should happen in under 2 seconds
    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(
        provider.isInitialized,
        true,
      );
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('CreateUser should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged in user should be able to be verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(
        user,
        isNotNull,
      );
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(
        user,
        isNotNull,
      );
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialize = false;
  bool get isInitialized => _isInitialize;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialize = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (email == 'foo@bar.com') {
      throw UserNotFoundAuthException();
    }
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
