import 'dart:async';

import 'package:dash/dash.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Bloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _username = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Observable<bool> get signInStatus => _isSignedIn.stream;

  Observable<String> get username => _username.stream;

  Observable<String> get gender => _gender.stream;

  Observable<String> get date => _date.stream;

  //String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail=> _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(String) get changeUsername => _username.sink.add;

  Function(String) get changeGender => _gender.sink.add;

  Function(String) get changeDate => _date.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError("Insira um endereço de e-mail válido.");
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 8) {
          sink.add(password);
        } else {
          sink.addError("A senha deve conter no mínimo 8 caracteres.");
        }
      });

  Future<void> signUp() {
    return _repository.registerUser(_email.value, _password.value, _username.value, _date.value, _gender.value);
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _username.drain();
    _username.close();
    await _gender.drain();
    _gender.close();
    await _date.drain();
    _date.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  static Bloc instance() => SignUpBloc();

/*bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 8) {
      return true;
    } else {
      return false;
    }
  }*/
}