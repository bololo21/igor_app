import 'dart:async';
import 'package:dash/dash.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CreateSessionBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get date => _date.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDate => _date.sink.add;


  Future<void> createSession() async {
    return _repository.createSession(_name.value, _date.value);
  }

  void dispose() async {
    await _name.drain();
    _name.close();
    await _date.drain();
    _date.close();
  }

  static Bloc instance() => CreateSessionBloc();

}