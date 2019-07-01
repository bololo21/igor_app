import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CreateSessionBloc extends Bloc {
  final _repository = Repository();
  final _adventureUid = BehaviorSubject<String>();
  final _sessionName = BehaviorSubject<String>();
  final _date = BehaviorSubject<DateTime>();

  Observable<String> get adventureName => _adventureUid.stream;
  Observable<String> get sessionName => _sessionName.stream;
  Observable<DateTime> get date => _date.stream;

  // Change data
  Function(String) get changeAdventureName => _adventureUid.sink.add;
  Function(String) get changeSessionName => _sessionName.sink.add;
  Function(DateTime) get changeDate => _date.sink.add;

  Future<void> createSession(String adventureUid) {
    return _repository.createSession(adventureUid, _sessionName.value, _date.value);
  }

  Future<void> updateSession(String sessionUid) {
    return _repository.updateSession(sessionUid, _sessionName.value, _date.value);
  }

  Stream<QuerySnapshot> getSessions(String adventureUid) {
    return _repository.getSessions(adventureUid);
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