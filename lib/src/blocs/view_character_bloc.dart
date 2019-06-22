import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/player.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ViewCharacterBloc extends Bloc {

  final _repository = Repository();
  final _characterName = BehaviorSubject<String>();
  final _characterRace = BehaviorSubject<String>();
  final _characterClass = BehaviorSubject<String>();
  final _attack = BehaviorSubject<String>();
  final _defense = BehaviorSubject<String>();
  final _life = BehaviorSubject<String>();
  final _avatar = BehaviorSubject<String>();


  Observable<String> get characterName => _characterName.stream;

  Function(String) get changeCharacterName => _characterName.sink.add;

  Observable<String> get characterClass => _characterClass.stream;

  Function(String) get changeCharacterClass => _characterClass.sink.add;

  Observable<String> get characterRace => _characterRace.stream;

  Function(String) get changeCharacterRace => _characterRace.sink.add;

  Observable<String> get attack => _attack.stream;

  Function(String) get changeAttack => _attack.sink.add;

  Observable<String> get defense => _defense.stream;

  Function(String) get changeDefense => _defense.sink.add;

  Observable<String> get life => _life.stream;

  Function(String) get changeLife => _life.sink.add;

  Observable<String> get avatar => _avatar.stream;

  Function(String) get changeAvatar => _avatar.sink.add;


  void dispose() async {
    await _characterName.drain();
    _characterName.close();
    await _characterClass.drain();
    _characterClass.close();
    await _characterRace.drain();
    _characterRace.close();
    await _attack.drain();
    _attack.close();
    await _defense.drain();
    _defense.close();
    await _life.drain();
    _life.close();
    await _avatar.drain();
    _avatar.close();
  }


  Stream<DocumentSnapshot> getCharacterData(String adventureUid, String userid) {
    return _repository.getCharacterData(adventureUid, userid);
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
        document.data["avatar"]
      );
    return player;
  }

  static Bloc instance() => ViewCharacterBloc();
}
