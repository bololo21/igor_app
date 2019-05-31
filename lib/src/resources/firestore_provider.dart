import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igor_app/src/models/user.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> registerUserData(String uid, String username, String date, String gender) {
    return _firestore
        .collection('users')
        .document(uid)
        .setData({'username': username, 'birthDate': date, 'gender': gender });
  }

  Stream<DocumentSnapshot> getUserData(String userUid) {
    return _firestore.collection('users').document(userUid).snapshots();
  }

  Future<void> registerAdventureData(String userUid, String masterUsername, String adventureName, String adventureDate, String description, String imagePath) {
    var adventure = _firestore
        .collection('adventures')
        .document();
    adventure.setData({'masterUid': userUid, 'createdAt': adventureDate, 'name': adventureName, 'description': description, 'imagePath': imagePath});
    return adventure.collection('players').document(userUid).setData({'playerUsername': masterUsername});
  }

  Future<void> createSessionData(String adventureName, String sessionDate) {
    return _firestore
        .collection('sessions')
        .document().setData({'adventureName': adventureName, 'sessionDate': sessionDate});
  }

  Future<void> registerPlayerData(String adventureUid, String playerUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid).collection('players').document(playerUid).setData({});
  }

  Stream<QuerySnapshot> myAdventures(String userUid) {
    var masterAdventures = _firestore.collection('adventures').where('masterUid', isEqualTo: userUid).snapshots();
    //var playerAdventures = _firestore.collection('adventures').where('players', arrayContains: userUid).snapshots();
    //return StreamZip(([masterAdventures, playerAdventures])).asBroadcastStream();
    return masterAdventures;
  }

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) {
    return _firestore.collection('adventures').document(adventureUid).snapshots();
  }

  Stream<QuerySnapshot> getUsersData() {
    return _firestore.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) {
    return _firestore.collection('adventures').document(adventureUid).collection('players').snapshots();
  }

  Future<void> addUserToAdventure(User user, String adventureUid) {
    return _firestore.collection('adventures').document(adventureUid).collection('players').document(user.id)
        .setData({'playerUsername': user.username});
  }

}