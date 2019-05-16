/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observable_state/observable_state.dart';

enum Changes {
  logIn,
  signUp,
}

class Session extends Observable<Changes> {
  FirebaseUser _currentUser;
  FirebaseUser get currentUser => _currentUser;

  void logIn(String email, String password) {
    setState(() async {
      _currentUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    }, notify: Changes.logIn);
  }

  // TODO: arrumar resto dos dados do usuário (erro com provider installer)
  void signUp(String email, String password, String username, String date, String gender) {
    setState(() async {
      _currentUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    }, notify: Changes.signUp);
  }

  void setData(String email, String username, String date, String gender) {
    Firestore.instance.collection('users').document(_currentUser.uid)
        .setData({'username': username, 'birthDate': date, 'gender': gender });
  }
}
*/