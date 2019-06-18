import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/player.dart';
import 'package:igor_app/src/models/session.dart';
import 'package:igor_app/src/models/user.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ViewAdventureBloc extends Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _description = BehaviorSubject<String>();

  Observable<String> get name => _name.stream;

  Observable<String> get description => _description.stream;

  // Change data
  Function(String) get changeName => _name.sink.add;

  Function(String) get changeDescription => _description.sink.add;

  void dispose() async {
    await _name.drain();
    _name.close();
    await _description.drain();
    _description.close();
  }

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) {
    return _repository.getUsersInAdventure(adventureUid);
  }

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) {
    return _repository.getAdventureData(adventureUid);
  }

  Adventure mapToAdventure({DocumentSnapshot document}) {
    Adventure adventure = Adventure(
        document.documentID,
        document.data["name"],
        document.data["description"],
        document.data["createdAt"],
        document.data["masterUid"],
        document.data["imagePath"]);
    return adventure;
  }

  List mapToUserList({List<DocumentSnapshot> docList}) {
    List<User> userList = [];
    docList.forEach((document) {
      User user = User(
          document.documentID,
          document.data["playerUsername"]
      );
      userList.add(user);
    });
    return userList;
  }


  List mapToPlayerList({List<DocumentSnapshot> docList}) {
    List<Player> playerList = [];
    docList.forEach((document) {
      Player player = Player(
        document.documentID,
        document.data["playerUsername"],
        document.data["characterName"],
        document.data["characterClass"],
        document.data["characterRace"],
        document.data["attack"],
        document.data["defense"],
        document.data["life"],
        document.data["avatar"]
      );
      playerList.add(player);
    });
    return playerList.reversed.toList();
  }

  List mapToSessionList({List<DocumentSnapshot> docList}) {
    List<Session> sessionList = [];
    docList.forEach((document) {
      Session session = Session(
          document.documentID,
          document.data["sessionName"],
          document.data["adventureUid"],
          document.data["sessionDate"]);
      sessionList.add(session);
    });
    return sessionList;
  }

  Stream<QuerySnapshot> getSessions(String adventureUid) {
    return _repository.getSessions(adventureUid);
  }

  static Bloc instance() => ViewAdventureBloc();
}
