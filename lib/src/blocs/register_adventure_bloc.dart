import 'dart:async';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class RegisterAdventureBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _description.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _description.sink.add;


  Future<void> registerAdventure() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    return _repository.registerAdventure(currentUser.uid, _name.value, DateTime.now().toString(), _description.value);
  }

  void dispose() async {
    await _name.drain();
    _name.close();
    await _description.drain();
    _description.close();
  }

  static Bloc instance() => RegisterAdventureBloc();

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