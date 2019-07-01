import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/session.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class IndexAdventureBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _description.stream;

  Observable<bool> get showProgress => _showProgress.stream;

  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _description.sink.add;

  Stream<QuerySnapshot> myMasterAdventures(String masterUid) {
    return _repository.myMasterAdventures(masterUid);
  }

  Stream<QuerySnapshot> myPlayerAdventures(String currentUser) {
    return _repository.myPlayerAdventures(currentUser);
  }

  deleteAdventure(String adventureUid) =>
      _repository.deleteAdventure(adventureUid);

  List mapToSessionList({List<DocumentSnapshot> docList}) {
    List<Session> sessionList = [];
    docList.forEach((document) {
      Session session = Session(
          document.documentID,
          document.data["sessionName"],
          document.data["adventureUid"],
          document.data["sessionDate"].toDate());

      sessionList.add(session);
    });

    if (sessionList.length <= 1)
      return sessionList;
    else
      return sessionList..sort((a, b) => a.date.compareTo(b.date));

  }

  Stream<QuerySnapshot> getNextSessions(String adventureUid) {
    return _repository.getNextSessions(adventureUid);
  }

  List mapToList({List<DocumentSnapshot> docList}) {
    List<Adventure> adventureList = [];
    docList.forEach((document) {
      Adventure adventure = Adventure(
          document.documentID,
          document.data["name"],
          document.data["description"],
          document.data["createdAt"],
          document.data["masterUid"],
          document.data["imagePath"]);
      adventureList.add(adventure);
    });
    return adventureList;
  }

  //dispose all open sink
  void dispose() async {
    await _name.drain();
    _name.close();
    await _description.drain();
    _description.close();
    await _showProgress.drain();
    _showProgress.close();
  }

  static Bloc instance() => IndexAdventureBloc();
}
