import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/adventures_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/models/adventure.dart';

import '../../app_config.dart';
import 'app_bar.dart';

class IndexAdventureScreen extends StatefulWidget {
  @override
  _IndexAdventureScreenState createState() => _IndexAdventureScreenState();
}

class _IndexAdventureScreenState extends State<IndexAdventureScreen> {
  final _bloc = $Provider.of<AdventuresBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IgorAppBar(),
        drawer: IgorDrawer(context),
        body: Container(
          decoration: new BoxDecoration(color: const Color(0xff221233)),
          alignment: Alignment(0.0, 0.0),
          child: StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  return StreamBuilder(
                    stream: _bloc.myAdventures(snapshot2.data.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        List<Adventure> adventuresList =
                            _bloc.mapToList(docList: docs);
                        if (adventuresList.isNotEmpty) {
                          return buildList(adventuresList);
                        } else {
                          return Text("No Goals");
                        }
                      } else {
                        return Text("No Goals");
                      }
                    },
                  );
                } else
                  return Text("");
              }),
        ));
  }

  ListView buildList(List<Adventure> adventuresList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            Divider(color: Colors.transparent, height: 3),
        itemCount: adventuresList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Stack(children: <Widget>[
              new Container(
                height: 20 * appConfig.blockSizeVertical,
                width: 100 * appConfig.blockSize,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage(
                        "assets/adventures/miniatura_krevast.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          15 * appConfig.blockSize,
                          3 * appConfig.blockSizeVertical,
                          15 * appConfig.blockSize,
                          3 * appConfig.blockSizeVertical),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(adventuresList[index].name,
                                style: TextStyle(
                                    fontFamily: 'Fira-sans',
                                    color: const Color(0xffe2e2e1),
                                    fontSize: 24)),
                          ),
                          SizedBox(height: 6 * appConfig.blockSizeVertical),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("próxima sessão 02/11",
                                style: TextStyle(
                                    fontFamily: 'Fira-sans',
                                    color: const Color(0xffe2e2e1),
                                    fontSize: 12)),
                          ),
                          SizedBox(height: 2 * appConfig.blockSizeVertical),
                          showProgressBar(adventuresList[index].id),
                        ],
                      ),
                    ),
                  ],
                ),
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

  // TODO - implementar showProgressBar
  Widget showProgressBar(int id) {
    return Stack(
      children: <Widget>[
        //Image.asset("assets/adventures/marcador_barra_de_progressão.png", width: 2 * appConfig.blockSize),
        Image.asset("assets/adventures/barra_de_progressão_jogadas.png", width: 100 * appConfig.blockSize),
      ]
    );
  }
}
