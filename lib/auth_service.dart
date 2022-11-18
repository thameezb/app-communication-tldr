import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  late final UserCredential _userCredential;

  Future init() async {
    try {
      // Anonymously authenticate with Firebase
      _userCredential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error: ${e.message}");
      }
    }
  }
}
