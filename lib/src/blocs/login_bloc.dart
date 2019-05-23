import 'dart:async';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password => _password.stream;

  Observable<bool> get signInStatus => _isSignedIn.stream;

  //String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError("Insira um endereço de e-mail válido.");
    }
  });

  Future<FirebaseUser> logIn() {
    return _repository.authenticateUser(_email.value, _password.value);
  }

  Future<void> logOut() {
    return _repository.logout();
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  static Bloc instance() => LoginBloc();

  /*bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }*/
}