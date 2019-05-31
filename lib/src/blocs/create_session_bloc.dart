import 'dart:async';
import 'package:dash/dash.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CreateSessionBloc extends Bloc {
  final _repository = Repository();
  final _adventureUid = BehaviorSubject<String>();
  final _sessionName = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();


  Observable<String> get adventureName => _adventureUid.stream;
  Observable<String> get sessionName => _sessionName.stream;
  Observable<String> get date => _date.stream;

  // Change data
  Function(String) get changeadventureName => _adventureUid.sink.add;
  Function(String) get changesessionName => _sessionName.sink.add;
  Function(String) get changeDate => _date.sink.add;


  Future<void> createSession() async {
    return _repository.createSession(_adventureUid.value, _sessionName.value, _date.value);
  }

  void dispose() async {
    await _adventureUid.drain();
    _adventureUid.close();
    await _sessionName.drain();
    _sessionName.close();
    await _date.drain();
    _date.close();
  }

  static Bloc instance() => CreateSessionBloc();

}