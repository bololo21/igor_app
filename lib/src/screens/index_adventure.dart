import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/adventures_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/models/adventure.dart';

import '../../app_config.dart';

class IndexAdventureScreen extends StatefulWidget {
  @override
  _IndexAdventureScreenState createState() => _IndexAdventureScreenState();
}

class _IndexAdventureScreenState extends State<IndexAdventureScreen> {
  final _bloc = $Provider.of<AdventuresBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            color: const Color(0xff221233)
          ),
      alignment: Alignment(0.0, 0.0),
      child: StreamBuilder(
        stream: _bloc.myAdventures(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Adventure> adventuresList = _bloc.mapToList(docList: docs);
            if (adventuresList.isNotEmpty) {
              return buildList(adventuresList);
            } else {
              return Text("No Goals");
            }
          } else {
            return Text("No Goals");
          }
        },
      ),
    ));
  }

  ListView buildList(List<Adventure> adventuresList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            Divider(color: Colors.transparent, height: 3),
        itemCount: adventuresList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Stack(
                children: <Widget>[
              new Container(
                height: 20 * appConfig.blockSizeVertical,
                width: 100 * appConfig.blockSize,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/adventures/miniatura_krevast.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Text(adventuresList[index].name),
              ),
            ]),
            onTap: () => print("aaa"),
          );
        });
  }

  @override
  void dispose() {
    $Provider.dispose<AdventuresBloc>();
    super.dispose();
  }
}
