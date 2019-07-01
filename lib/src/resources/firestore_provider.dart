import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igor_app/src/models/user.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> registerUserData(
      String uid, String username, String date, String gender) {
    return _firestore
        .collection('users')
        .document(uid)
        .setData({'username': username, 'birthDate': date, 'gender': gender});
  }

  Stream<DocumentSnapshot> getUserData(String userUid) {
    return _firestore.collection('users').document(userUid).snapshots();
  }

  deleteInvite(String inviteId) {
    return _firestore.collection('invites').document(inviteId).delete();
  }

  Future<void> registerAdventureData(
      String userUid,
      String masterUsername,
      String adventureName,
      String adventureDate,
      String description,
      String imagePath) {
    var adventure = _firestore.collection('adventures').document();
    adventure.setData({
      'masterUid': userUid,
      'createdAt': adventureDate,
      'name': adventureName,
      'description': description,
      'imagePath': imagePath
    });
    return adventure
        .collection('players')
        .document(userUid)
        .setData({'playerUsername': masterUsername, 'characterName': "MESTRE"});
  }

  deleteAdventure(String adventureUid) {
    _firestore
        .collection('sessions')
        .where('adventureUid', isEqualTo: adventureUid)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    return _firestore.collection('adventures').document(adventureUid).delete();
  }

  Future<void> createSessionData(
      String adventureUid, String sessionName, String sessionDate) {
    return _firestore.collection('sessions').document().setData({
      'adventureUid': adventureUid,
      'sessionName': sessionName,
      'sessionDate': sessionDate
    });
  }

  deleteSession(String sessionUid) {
    return _firestore.collection('sessions').document(sessionUid).delete();
  }

  Stream<QuerySnapshot> myMasterAdventures(String userUid) {
    var masterAdventures = _firestore
        .collection('adventures')
        .where('masterUid', isEqualTo: userUid)
        .snapshots();
    return masterAdventures;
  }

  Stream<QuerySnapshot> myPlayerAdventures(String userUid) {
    var playerAdventures = _firestore
        .collection('adventures')
        .where('players', arrayContains: userUid)
        .snapshots();
    return playerAdventures;
  }

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getCharacterData(
      String adventureUid, String userUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .document(userUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getSessions(String adventureUid) {
    return _firestore
        .collection('sessions')
        .where('adventureUid', isEqualTo: adventureUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getInvites(String userUid) {
    return _firestore
        .collection('invites')
        .where('userUid', isEqualTo: userUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersData() {
    return _firestore.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .snapshots();
  }

  Stream<QuerySnapshot> getInvitedUsers(String adventureUid) {
    return _firestore
        .collection('invites')
        .where('adventureUid', isEqualTo: adventureUid)
        .snapshots();
  }

  Future<void> addUserToAdventure(User user, String adventureUid) {
    _firestore.collection('adventures').document(adventureUid).updateData({
      "players": FieldValue.arrayUnion([user.id])
    });
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .document(user.id)
        .setData({
      'playerUsername': user.username,
      'characterName': '',
      'characterRace': '',
      'characterClass': '',
      'attack': '',
      'defense': '',
      'life': '',
      'avatar': ''
    });
  }

  Future<void> inviteUser(User user, String adventureUid) {
    return _firestore
        .collection('invites')
        .document()
        .setData({'adventureUid': adventureUid, 'userUid': user.id});
  }

  Future<void> addCharacterToAdventure(
      String userUid,
      String adventureUid,
      String characterName,
      String characterClass,
      String characterRace,
      String attack,
      String defense,
      String life,
      String avatar) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .document(userUid)
        .updateData({
      'characterName': characterName,
      'characterClass': characterClass,
      'characterRace': characterRace,
      'attack': attack,
      'defense': defense,
      'life': life,
      'avatar': avatar
    });
  }

  Future<void> insertIntoSessionLog(
      String sessionUid, int diceValue, String playerName, String dice) {
    return _firestore
        .collection('sessions')
        .document(sessionUid)
        .collection('logs')
        .document()
        .setData({
      'characterName': playerName,
      'diceValue': diceValue,
      'dice': dice,
      'timestamp': DateTime.now()
    });
  }

  Stream<DocumentSnapshot> getCurrentUserPlayer(
      String userUid, String adventureUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .document(userUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getSessionLog(String sessionUid) {
    return _firestore
        .collection('sessions')
        .document(sessionUid)
        .collection('logs')
        .snapshots();
  }

  Future<void> updateAdventure(String adventureUid, String adventureName,
      String description, String imagePath) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .updateData({
      'name': adventureName,
      'description': description,
      'imagePath': imagePath
    });
  }

  Future<void> updateSession(String sessionUid, String sessionName, String sessionDate) {
    return _firestore.collection('sessions').document(sessionUid).updateData({
      'sessionName': sessionName,
      'sessionDate': sessionDate
    });
  }

  Future<void> leaveAdventure(String playerUid, String adventureUid) {
    var adventure = _firestore.collection('adventures').document(adventureUid);
    adventure.updateData({
      "players": FieldValue.arrayRemove([playerUid])
    });
    return adventure.collection('players').document(playerUid).delete();

  }
}
