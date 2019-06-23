import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/log.dart';
import 'package:igor_app/src/models/player.dart';
import '../resources/repository.dart';

class SessionLogBloc extends Bloc {
  final _repository = Repository();

  Stream<DocumentSnapshot> getCurrentUserPlayer(
      String userUid, String adventureUid) {
    return _repository.getCurrentUserPlayer(userUid, adventureUid);
  }

  Future<void> insertIntoSessionLog(
      String sessionUid, int diceValue, String playerName) {
    return _repository.insertIntoSessionLog(sessionUid, diceValue, playerName);
  }

  Player mapToPlayer(DocumentSnapshot document) {
    Player player = Player(
        document.documentID,
        document.data["playerUsername"],
        document.data["characterName"],
        document.data["characterClass"],
        document.data["characterRace"],
        document.data["attack"],
        document.data["defense"],
        document.data["life"],
        document.data["avatar"]);
    return player;
  }

  List mapToLogList({List<DocumentSnapshot> docList}) {
    List<Log> logList = [];
    docList.forEach((document) {
      Log log = Log(document.documentID, document.data["characterName"],
          document.data["diceValue"], document.data["timestamp"]);
      logList.add(log);
    });

    if (logList.length == 1)
      return logList;
    else
      return logList..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  //dispose all open sink
  void dispose() async {}

  static Bloc instance() => SessionLogBloc();

  Stream<QuerySnapshot> getSessionLog(String sessionUid) {
    return _repository.getSessionLog(sessionUid);
  }
}
