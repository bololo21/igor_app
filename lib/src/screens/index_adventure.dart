import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/index_adventure_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/screens/view_adventure.dart';
import '../../app_config.dart';
import 'app_bar.dart';

class IndexAdventureScreen extends StatefulWidget {
  @override
  _IndexAdventureScreenState createState() => _IndexAdventureScreenState();
}

class _IndexAdventureScreenState extends State<IndexAdventureScreen> {
  final _bloc = $Provider.of<IndexAdventureBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          width: 17 * appConfig.blockSize,
          height: 17 * appConfig.blockSize,
          child: FloatingActionButton(
            child:
                Image.asset('assets/adventures/Botão_Criar_Nova_Aventura.webp'),
            onPressed: () =>
                Navigator.pushNamed(context, '/register_adventure'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: IgorAppBar(),
        drawer: IgorDrawer(context),
        body: Container(
          decoration: new BoxDecoration(color: const Color(0xff221233)),
          alignment: Alignment(0.0, 0.0),
          child: StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, currentUser) {
                if (currentUser.hasData) {
                  return
                      StreamBuilder(
                        stream: _bloc.myMasterAdventures(currentUser.data.uid),
                        builder: (context, masterSnapshot) {
                          return StreamBuilder(
                            stream: _bloc.myPlayerAdventures(currentUser.data.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && masterSnapshot.hasData) {
                                List<DocumentSnapshot> masterDocs =
                                    masterSnapshot.data.documents;
                                List<Adventure> masterAdventuresList =
                                _bloc.mapToList(docList: masterDocs);
                                List<DocumentSnapshot> docs =
                                    snapshot.data.documents;
                                List<Adventure> adventuresList =
                                _bloc.mapToList(docList: docs);
                                if (masterAdventuresList.isNotEmpty || adventuresList.isNotEmpty) {
                                  List<Adventure> finalList = new List.from(masterAdventuresList)..addAll(adventuresList);
                                  return buildList(finalList);
                                } else {
                                  return Text(
                                      "Você ainda não criou nenhuma aventura2 :(",
                                      style: TextStyle(
                                          fontFamily: 'Fira-sans',
                                          color: const Color(0xffe2e2e1)));
                                }
                              } else {
                                return Text("Carregando...",
                                    style: TextStyle(
                                        fontFamily: 'Fira-sans',
                                        color: const Color(0xffe2e2e1)));
                              }
                            },
                          );

                        },
                      );


                } else
                  return Text("Carregando...",
                      style: TextStyle(
                          fontFamily: 'Fira-sans',
                          color: const Color(0xffe2e2e1)));
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
                        "assets/adventures/${adventuresList[index].imagePath}.webp"),
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
                          SizedBox(height: 5 * appConfig.blockSizeVertical),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Próxima sessão: 02/11",
                                style: TextStyle(
                                    fontFamily: 'Fira-sans',
                                    color: const Color(0xffe2e2e1),
                                    fontSize: 12)),
                          ),
                          SizedBox(height: appConfig.blockSizeVertical),
                          showProgressBar(adventuresList[index].id),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAdventureScreen(
                        adventureUid: adventuresList[index].id.toString()))),
          );
        });
  }

  @override
  void dispose() {
    $Provider.dispose<IndexAdventureBloc>();
    super.dispose();
  }

  // TODO - implementar showProgressBar
  Widget showProgressBar(String id) {
    return Stack(children: <Widget>[
      //Image.asset("assets/adventures/marcador_barra_de_progressão.webp", width: 2 * appConfig.blockSize),
      Image.asset("assets/adventures/barra_de_progressão_jogadas.webp",
          width: 100 * appConfig.blockSize),
    ]);
  }
}
