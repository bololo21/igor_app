import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> authenticateUser(String email, String password) {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> signUpUser(String email, String password, String username, String date, String gender) {
    return _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
  }

}