import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class RegisterAdventureBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _imagePath = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _description.stream;

  Observable<String> get imagePath => _imagePath.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _description.sink.add;

  Function(String) get changeImagePath => _imagePath.sink.add;


  Future<void> registerAdventure() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    Stream<DocumentSnapshot> currentUserData = _repository.getUserData(currentUser.uid);
    return currentUserData.listen((user) => _repository.registerAdventure(currentUser.uid, user.data["username"], _name.value, DateTime.now().toString(), _description.value, _imagePath.value));
  }

  Stream<DocumentSnapshot> getUserData(String userUid) => _repository.getUserData(userUid);

  void dispose() async {
    await _name.drain();
    _name.close();
    await _description.drain();
    _description.close();
    await _imagePath.drain();
    _imagePath.close();
  }

  static Bloc instance() => RegisterAdventureBloc();

}