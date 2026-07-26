import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// The "Web client (auto created by Google Service)" OAuth client from
/// google-services.json — required as `serverClientId` so Android's native
/// Google Sign-In returns an ID token Firebase will accept.
const _googleServerClientId =
    '579736019531-1g5bm4jt29gpa81h2pv3ls8o15mff3o2.apps.googleusercontent.com';

/// Wraps [FirebaseAuth] and Google Sign-In so screens call one place instead
/// of the Firebase/Google SDKs directly.
class AuthService {
  /// Must be awaited once at app startup, before any sign-in attempt.
  static Future<void> initialize() async {
    // Web uses FirebaseAuth.signInWithPopup directly instead of this plugin.
    if (!kIsWeb) {
      await GoogleSignIn.instance.initialize(serverClientId: _googleServerClientId);
    }
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (name != null && name.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(name.trim());
    }
    return credential;
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      return FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    }
    final account = await GoogleSignIn.instance.authenticate();
    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
