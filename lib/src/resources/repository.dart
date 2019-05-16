import 'package:firebase_auth/firebase_auth.dart';

import 'package:igor_app/src/resources/firestore_provider.dart';
import 'package:igor_app/src/resources/firebaseauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _firebaseAuthProvider = FirebaseAuthProvider();

  Future<FirebaseUser> authenticateUser(String email, String password) =>
      _firebaseAuthProvider.authenticateUser(email, password);

  Future<void> registerUser(String email, String password, String username, String date, String gender) async {
    FirebaseUser user = await _firebaseAuthProvider.signUpUser(email, password, username, date, gender);
    return _firestoreProvider.registerUserData(user.uid, username, date, gender);
  }
}