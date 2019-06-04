import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SessionsBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _date.stream;

  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _date.sink.add;

  Stream<QuerySnapshot> getSessions(String adventureUid) {
    //var currentUser = await FirebaseAuth.instance.currentUser();
    return _repository.getSessions(adventureUid);
  }

  //dispose all open sink
  void dispose() async {
    await _name.drain();
    _name.close();
    await _date.drain();
    _date.close();
  }

  static Bloc instance() => SessionsBloc();

}