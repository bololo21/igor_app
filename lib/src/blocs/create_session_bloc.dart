import 'dart:async';
import 'package:dash/dash.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CreateSessionBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _description.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _description.sink.add;


  Future<void> createSession() async {
    return _repository.createSession(_name.value, DateTime.now().toString());
  }

  void dispose() async {
    await _name.drain();
    _name.close();
    await _description.drain();
    _description.close();
  }

  static Bloc instance() => CreateSessionBloc();

}