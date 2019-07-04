import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/models/user.dart';
import 'package:http/http.dart' as http;


class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

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

  Future<void> createSessionData(
      String adventureUid, String sessionName, DateTime sessionDate) {
    if (sessionDate == null) sessionDate = DateTime.now();
    if (sessionName == null) sessionName = "Sessão sem nome";
    return _firestore.collection('sessions').document().setData({
      'adventureUid': adventureUid,
      'sessionName': sessionName,
      'sessionDate': sessionDate
    });
  }

  deleteAdventure(String adventureUid) {
    var adventure = _firestore.collection('adventures').document(adventureUid);
    _firestore
        .collection('sessions')
        .where('adventureUid', isEqualTo: adventureUid)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot sessionDS in snapshot.documents) {
        sessionDS.reference.collection('logs').getDocuments().then((logs) {
          for (DocumentSnapshot logDS in logs.documents) {
            logDS.reference.delete();
          }
        });
        sessionDS.reference.delete();
      }
    });
    _firestore
        .collection('invites')
        .where('adventureUid', isEqualTo: adventureUid)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    adventure.collection('players').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    return adventure.delete();
  }

  deleteInvite(String inviteId) {
    return _firestore.collection('invites').document(inviteId).delete();
  }

  deleteSession(String sessionUid) {
    var session = _firestore.collection('sessions').document(sessionUid);
    session.collection('logs').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    return session.delete();
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

  Stream<DocumentSnapshot> getCurrentUserPlayer(
      String userUid, String adventureUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid)
        .collection('players')
        .document(userUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getInvitedUsers(String adventureUid) {
    return _firestore
        .collection('invites')
        .where('adventureUid', isEqualTo: adventureUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getInvites(String userUid) {
    return _firestore
        .collection('invites')
        .where('userUid', isEqualTo: userUid)
        .snapshots();
  }

  Stream<QuerySnapshot> getNextSessions(String adventureUid) => _firestore
      .collection('sessions')
      .where('adventureUid', isEqualTo: adventureUid)
      .where('sessionDate', isGreaterThanOrEqualTo: DateTime.now())
      .snapshots();

  Stream<QuerySnapshot> getSessionLog(String sessionUid) {
    return _firestore
        .collection('sessions')
        .document(sessionUid)
        .collection('logs')
        .snapshots();
  }

  Stream<QuerySnapshot> getSessions(String adventureUid) {
    return _firestore
        .collection('sessions')
        .where('adventureUid', isEqualTo: adventureUid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getUserData(String userUid) {
    return _firestore.collection('users').document(userUid).snapshots();
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

  Future<void> inviteUser(User user, String adventureUid) {
    return _firestore
        .collection('invites')
        .document()
        .setData({'adventureUid': adventureUid, 'userUid': user.id});
  }

  Future<void> leaveAdventure(String playerUid, String adventureUid) {
    var adventure = _firestore.collection('adventures').document(adventureUid);
    adventure.updateData({
      "players": FieldValue.arrayRemove([playerUid])
    });
    return adventure.collection('players').document(playerUid).delete();
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

  Future<void> registerAdventureData(
      String userUid,
      String masterUsername,
      String adventureName,
      String adventureDate,
      String description,
      String imagePath) {
    if (adventureName == null) adventureName = "Aventura sem nome";
    if (description == null) description = "Aventura sem descrição";
    if (imagePath == null) imagePath = "Padrão";
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

  Future<void> registerUserData(
      String uid, String username, String date, String gender) {
    return _firestore
        .collection('users')
        .document(uid)
        .setData({'username': username, 'birthDate': date, 'gender': gender});
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

  Future<void> updateSession(
      String sessionUid, String sessionName, DateTime sessionDate) {
    return _firestore
        .collection('sessions')
        .document(sessionUid)
        .updateData({'sessionName': sessionName, 'sessionDate': sessionDate});
  }

  saveDeviceToken() async {
    // Get the current user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    // Get the token for this device
    String fcmToken = await appConfig.firebaseMessaging.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      _firestore
          .collection('users')
          .document(user.uid).updateData({"token": fcmToken});
    }
  }

  Future<bool> sendNotification({String title, String body,String deviceTarget}) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": deviceTarget
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AIzaSyA7IB1hfF6VOpa_aOMnXK4weQltRAxwNAY'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // on success do sth
      return true;
    } else {
      // on failure do sth
      return false;
    }
  }

}
