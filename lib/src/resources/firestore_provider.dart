import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> registerUserData(String uid, String username, String date, String gender) {
    return _firestore
        .collection('users')
        .document(uid)
        .setData({'username': username, 'birthDate': date, 'gender': gender });
  }

  Future<void> registerAdventureData(String userUid, String adventureName, String adventureDate, String description ) {
    return _firestore
        .collection('adventures')
        .document().setData({'masterUid': userUid, 'createdAt': adventureDate, 'name': adventureName, 'description' : description });
  }

  Future<void> registerPlayerData(String adventureUid, String playerUid) {
    return _firestore
        .collection('adventures')
        .document(adventureUid).collection('players').document(playerUid).setData({});
  }

  Stream<QuerySnapshot> myAdventures(String userUid) {
    return _firestore.collection("adventures").where('masterUid', isEqualTo: userUid).snapshots();
  }

}