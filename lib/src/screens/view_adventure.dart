import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/view_adventure_bloc.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/player.dart';
import 'package:igor_app/src/models/session.dart';
import 'package:igor_app/src/screens/add_user.dart';
import 'package:igor_app/src/screens/create_session.dart';
import 'package:igor_app/src/screens/view_character.dart';
import '../../app_config.dart';
import 'add_character.dart';
import 'app_bar.dart';

class ViewAdventureScreen extends StatefulWidget {
  final String adventureUid;
  const ViewAdventureScreen({Key key, @required this.adventureUid})
      : super(key: key);

  @override
  _ViewAdventureScreenState createState() => _ViewAdventureScreenState();
}

class _ViewAdventureScreenState extends State<ViewAdventureScreen> {
  final _bloc = $Provider.of<ViewAdventureBloc>();
  String imagePath = 'assets/adventures/andamento.webp';
  int aba = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          width: 17 * appConfig.blockSize,
          height: 17 * appConfig.blockSize,
          child: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, currentUser) {
              if (currentUser.hasData) {
                return StreamBuilder(
                    stream: _bloc.getAdventureData(widget.adventureUid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Adventure adventure =
                            _bloc.mapToAdventure(document: snapshot.data);
                        return returnButton(currentUser.data.uid, adventure);
                      } else
                        return Text("");
                    });
              } else
                return Text("");
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: IgorAppBar(),
        drawer: IgorDrawer(context),
        body: StreamBuilder(
          stream: _bloc.getAdventureData(widget.adventureUid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Adventure adventure =
                  _bloc.mapToAdventure(document: snapshot.data);
              appConfig.setThemeColor(adventure);
              return showAdventureData(adventure);
            } else {
              return Text("Carregando...",
                  style: TextStyle(
                      fontFamily: 'Fira-sans', color: const Color(0xffe2e2e1)));
            }
          },
        ));
  }

  @override
  void dispose() {
    $Provider.dispose<ViewAdventureBloc>();
    super.dispose();
  }

  Widget showAdventureData(Adventure adventure) {
    return Container(
        decoration: new BoxDecoration(color: appConfig.themeColor),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage(
                             "assets/adventures/${adventure.imagePath}.webp"))),
                width: 100 * appConfig.blockSize,
                height: 17 * appConfig.blockSizeVertical,
              ),
              top: 0,
            ),
            Positioned(
              child: Text(
                "${adventure.name}",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              top: 4 * appConfig.blockSizeVertical,
              left: 15 * appConfig.blockSize,
            ),
            Positioned(
              child: Image.asset(imagePath),
              top: 8 * appConfig.blockSizeVertical,
              bottom: 22 * appConfig.blockSizeVertical,
              left: 1 * appConfig.blockSize,
              right: 1 * appConfig.blockSize,
            ),
            Positioned(
              child: Container(
                  height: 5 * appConfig.blockSizeVertical,
                  width: 40 * appConfig.blockSize,
                  child: MaterialButton(
                    child: Text("ANDAMENTO",
                        style:
                            TextStyle(fontFamily: 'Fira-sans', fontSize: 16)),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => setState(() {
                          imagePath = 'assets/adventures/andamento.webp';
                          aba = 1;
                        }),
                  )),
              top: 16 * appConfig.blockSizeVertical,
              left: 7 * appConfig.blockSize,
            ),
            Positioned(
              child: Container(
                  height: 5 * appConfig.blockSizeVertical,
                  width: 40 * appConfig.blockSize,
                  child: MaterialButton(
                    child: Text("JOGADORES",
                        style:
                            TextStyle(fontFamily: 'Fira-sans', fontSize: 16)),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => setState(() {
                          imagePath = 'assets/adventures/jogadores.webp';
                          aba = 2;
                        }),
                  )),
              top: 16 * appConfig.blockSizeVertical,
              right: 7 * appConfig.blockSize,
            ),
            Positioned(
              child: showTabContent(adventure),
              top: 23 * appConfig.blockSizeVertical,
              left: 9 * appConfig.blockSize,
            ),
          ],
        ));
  }

  Widget showTabContent(Adventure adventure) {
    if (aba == 1) {
      return Container(
        width: 80 * appConfig.blockSize,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20),
                child: Text(adventure.description,
                    style: TextStyle(fontFamily: 'Fira-sans', fontSize: 16),
                    textAlign: TextAlign.justify)),
            Container(
                padding: EdgeInsets.only(left: 15),
                child: Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Column(
                      children: <Widget>[
                        Divider(color: Colors.grey[800]),
                        StreamBuilder(
                            stream: _bloc.getSessions(widget.adventureUid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> docs =
                                    snapshot.data.documents;
                                List<Session> sessionList =
                                    _bloc.mapToSessionList(docList: docs);

                                if (sessionList.isEmpty)
                                  return Text(
                                      "Ainda não há sessões para esta aventura :(");
                                else
                                  return Container(
                                    height: 33 * appConfig.blockSizeVertical,
                                    width: 82 * appConfig.blockSize,
                                    child: ListView(
                                      children: sessionList.map((session) {
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(session.date,
                                                    style: TextStyle(
                                                        fontFamily: 'Fira-sans',
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            SizedBox(
                                                width: 2 * appConfig.blockSize),
                                            Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(session.name)),
                                            SizedBox(height: 10),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  );
                              } else
                                return Text("Carregando...");
                            })
                      ],
                    ))),
          ],
        ),
      );
    } else {
      return StreamBuilder(
        stream: _bloc.getUsersInAdventure(widget.adventureUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Player> usersInAdventureList =
                _bloc.mapToPlayerList(docList: docs);
            Player master = usersInAdventureList
                .firstWhere((player) => player.id == adventure.masterUid);
            usersInAdventureList.remove(master);
            return Column(
              children: <Widget>[
                showMasterCard(master),
                Container(
                  height: 33 * appConfig.blockSizeVertical,
                  width: 82 * appConfig.blockSize,
                  child: ListView(
                    children: usersInAdventureList.map((user) {
                      return Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 2 * appConfig.blockSize),
                                  Column(
                                    children: <Widget>[
                                      user.avatar == ""
                                          ? Container(
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                              ),
                                              height: 5 *
                                                  appConfig.blockSizeVertical,
                                              width: 5 *
                                                  appConfig.blockSizeVertical,
                                            )
                                           : GestureDetector(
                                           onTap:() =>  
                                           Navigator.push( context,
                                              MaterialPageRoute(
                                                   builder: (context) => ViewCharacterScreen(adventureUid: widget.adventureUid,
                                                     userUid: user.id))),
                                            child: Container(
                                              height: 5 *
                                                  appConfig.blockSizeVertical,
                                              width: 5 *
                                                  appConfig.blockSizeVertical,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new ExactAssetImage(
                                                          'assets/players/${user.avatar}.webp')))
                                            )
                                          ),
                                    ],
                                  ),
                                  SizedBox(width: 5 * appConfig.blockSize),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          width: 60 * appConfig.blockSize,
                                          alignment: Alignment.topLeft,
                                          child: user.characterName == ""
                                              ? Text("Personagem não definido",
                                                  style: TextStyle(
                                                      color: Colors.black38,
                                                      fontFamily: 'Fira-sans',
                                                      fontStyle:
                                                          FontStyle.italic))
                                              : Text(user.characterName,
                                                  style: TextStyle(
                                                      fontFamily: 'Fira-sans',
                                                      fontWeight:
                                                          FontWeight.bold))),
                                      Container(
                                        width: 60 * appConfig.blockSize,
                                        alignment: Alignment.topLeft,
                                        child: Text(user.username,
                                            style: TextStyle(
                                                fontFamily: 'Fira-sans',
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 1 * appConfig.blockSizeVertical),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else
            return Text("Carregando...");
        },
      );
    }
  }

  Widget returnButton(String currentUserUid, Adventure adventure) {
    if (currentUserUid == adventure.masterUid) {
      if (aba == 1) {
        return FloatingActionButton(
          child: Image.asset('assets/adventures/botão_adicionar_sessões.webp'),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterSessionScreen(
                      adventureUid: widget.adventureUid))),
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      } else {
        return FloatingActionButton(
          child:
              Image.asset('assets/adventures/botão_adicionar_jogadores.webp'),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddUserScreen(adventureUid: widget.adventureUid))),
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      }
    } else {
      if (aba == 1)
        return Text("");
      else
        return FloatingActionButton(
          child:
              Image.asset('assets/adventures/botão_adicionar_jogadores.webp'),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCharacterScreen(
                      adventureUid: widget.adventureUid,
                      userUid: currentUserUid))),
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
    }
  }

  Widget showMasterCard(Player master) {
    return Container(
      width: 82 * appConfig.blockSize,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    height: 7 * appConfig.blockSizeVertical,
                    width: 7 * appConfig.blockSizeVertical,
                  ),
                ],
              ),
              SizedBox(width: 5 * appConfig.blockSize),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Mestre ",
                        style: TextStyle(
                            fontFamily: 'Fira-sans',
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(master.username,
                        style: TextStyle(
                            fontFamily: 'Fira-sans',
                            fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1 * appConfig.blockSizeVertical),
        ],
      ),
    );
  }
}
