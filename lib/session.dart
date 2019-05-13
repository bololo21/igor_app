import 'package:firebase_auth/firebase_auth.dart';
import 'package:observable_state/observable_state.dart';

enum Changes{
  logIn,
  signUp,
}

class Session extends Observable<Changes>{
  FirebaseUser _currentUser;
  FirebaseUser get currentUser => _currentUser;

  void logIn(String email, String password) {
    setState(() async {
      _currentUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    }, notify: Changes.logIn);
  }

  void signUp(String email, String password) {
    setState(() async {
      _currentUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    }
    , notify: Changes.signUp);
  }
}
