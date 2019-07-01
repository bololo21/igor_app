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
import 'package:igor_app/src/screens/session_log.dart';
import 'package:igor_app/src/screens/view_character.dart';
import 'package:intl/intl.dart';

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

class _ViewAdventureScreenState extends State<ViewAdventureScreen>
    with SingleTickerProviderStateMixin {
  final _bloc = $Provider.of<ViewAdventureBloc>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
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
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  Widget returnButton(String currentUserUid, Adventure adventure) {
    if (currentUserUid == adventure.masterUid) {
      if (_tabController.index == 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              child:
                  Image.asset('assets/adventures/botão_adicionar_sessões.webp'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterSessionScreen(
                          adventureUid: widget.adventureUid))),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: Image.asset(
                  'assets/adventures/botão_adicionar_jogadores.webp'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddUserScreen(adventureUid: widget.adventureUid))),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        );
      }
    } else {
      if (_tabController.index == 0)
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

  Widget showAdventureData(Adventure adventure) {
    return Container(
        decoration: new BoxDecoration(color: appConfig.themeColor),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/adventures/${adventure.imagePath}.webp"))),
                width: 100 * appConfig.blockSize,
                height: 17 * appConfig.blockSizeVertical,
              ),
            ),
            Positioned(
              top: 15 * appConfig.blockSizeVertical,
              left: 5 * appConfig.blockSize,
              right: 5 * appConfig.blockSize,
              child: Container(
                decoration: new BoxDecoration(
                    color: const Color(0xffe2e2e1),
                    borderRadius: new BorderRadius.all(Radius.circular(7.0))),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        controller: _tabController,
                        labelColor: appConfig.themeColor,
                        indicatorColor: appConfig.themeColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                              child: Text("ANDAMENTO",
                                  style: TextStyle(
                                      fontFamily: 'Fira-sans', fontSize: 16))),
                          Tab(
                              child: Text("JOGADORES",
                                  style: TextStyle(
                                      fontFamily: 'Fira-sans', fontSize: 16))),
                        ],
                      ),
                      Container(
                        height: 55 * appConfig.blockSizeVertical,
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            showDetails(adventure),
                            showPlayers(adventure),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
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

  Widget showDetails(Adventure adventure) {
    return Container(
      padding: EdgeInsets.all(7 * appConfig.blockSize),
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 7 * appConfig.blockSize),
              child: Text(adventure.description,
                  style: TextStyle(fontFamily: 'Fira-sans', fontSize: 16),
                  textAlign: TextAlign.justify)),
          Divider(color: Colors.grey[800]),
          Container(
              padding: EdgeInsets.only(top: 5 * appConfig.blockSize),
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: _bloc.getSessions(widget.adventureUid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        List<Session> sessionList =
                            _bloc.mapToSessionList(docList: docs);

                        if (sessionList.isEmpty)
                          return Text(
                              "Ainda não há sessões para esta aventura :(");
                        else
                          return showSessions(adventure, sessionList);
                      } else
                        return Text("Carregando...");
                    }),
              )),
        ],
      ),
    );
  }

  Widget showPlayers(Adventure adventure) {
    return Container(
      padding: EdgeInsets.all(7 * appConfig.blockSize),
      child: StreamBuilder(
        stream: _bloc.getUsersInAdventure(widget.adventureUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<Player> usersInAdventureList =
                _bloc.mapToPlayerList(docList: docs);
            Player master = usersInAdventureList
                .firstWhere((player) => player.id == adventure.masterUid);
            usersInAdventureList.remove(master);
            return StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, currentUserSnapshot) {
                if (currentUserSnapshot.hasData) {
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    playerInfo(user),
                                    deletePlayer(adventure, user),
                                  ],
                                ),
                                SizedBox(
                                    height: 1 * appConfig.blockSizeVertical),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                } else
                  return Text("");
              },
            );
          } else
            return Text("Carregando...");
        },
      ),
    );
  }

  Widget adminButtons(Adventure adventure, Session session) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, currentUserSnapshot) {
          if (currentUserSnapshot.hasData &&
              currentUserSnapshot.data.uid == adventure.masterUid)
            return Row(
              children: <Widget>[
                Text("  | "),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterSessionScreen(
                                adventureUid: session.adventureUid,
                                session: session,
                              ))),
                  child: Icon(Icons.edit),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Atenção!"),
                            elevation: 0,
                            backgroundColor: const Color(0xffffffff),
                            content: SingleChildScrollView(
                                child: ListBody(
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text:
                                              'Tem certeza de que deseja excluir a sessão '),
                                      new TextSpan(
                                          text: session.name,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      new TextSpan(text: ' desta aventura?'),
                                    ],
                                  ),
                                )
                              ],
                            )),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("NÃO")),
                              FlatButton(
                                  onPressed: () {
                                    _bloc.deleteSession(session.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text("SIM"))
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.delete_outline),
                ),
              ],
            );
          else
            return Text("");
        });
  }

  Widget deletePlayer(Adventure adventure, Player player) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, currentUserSnapshot) {
        if (currentUserSnapshot.hasData &&
            (currentUserSnapshot.data.uid == player.id ||
                currentUserSnapshot.data.uid == adventure.masterUid))
          return IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Atenção!"),
                      elevation: 0,
                      backgroundColor: const Color(0xffffffff),
                      content: SingleChildScrollView(
                          child: ListBody(
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.center,
                            text:
                            currentUserSnapshot.data.uid == player.id ?
                            new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text:
                                        'Tem certeza de que deseja sair desta aventura?'),
                              ],
                            ):
                            new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text:
                                    'Tem certeza de que deseja excluir o personagem de '),
                                new TextSpan(
                                    text: player.username,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold)),
                                new TextSpan(text: ' desta aventura?'),
                              ],
                            ),
                          )
                        ],
                      )),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("NÃO")),
                        FlatButton(
                            onPressed: () {
                              _bloc.leaveAdventure(player.id, adventure.id);
                              Navigator.pop(context);
                            },
                            child: Text("SIM"))
                      ],
                    );
                  }));
        else
          return Text("");
      },
    );
  }

  Widget playerInfo(Player user) {
    return Row(
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
                    height: 5 * appConfig.blockSizeVertical,
                    width: 5 * appConfig.blockSizeVertical,
                  )
                : GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCharacterScreen(
                                adventureUid: widget.adventureUid,
                                userUid: user.id))),
                    child: Container(
                        height: 5 * appConfig.blockSizeVertical,
                        width: 5 * appConfig.blockSizeVertical,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new ExactAssetImage(
                                    'assets/players/${user.avatar}.webp'))))),
          ],
        ),
        SizedBox(width: 5 * appConfig.blockSize),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: user.characterName == ""
                    ? Text("Personagem não definido",
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Fira-sans',
                            fontStyle: FontStyle.italic))
                    : Text(user.characterName,
                        style: TextStyle(
                            fontFamily: 'Fira-sans',
                            fontWeight: FontWeight.bold))),
            Container(
              alignment: Alignment.topLeft,
              child: Text(user.username,
                  style: TextStyle(
                      fontFamily: 'Fira-sans', fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      ],
    );
  }

  Widget showSessions(Adventure adventure, List<Session> sessionList) {
    return Container(
      height: 20 * appConfig.blockSizeVertical,
      child: ListView(
        children: sessionList.map((session) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(DateFormat('dd/MM/yyyy').format(session.date),
                              style: TextStyle(
                                  fontFamily: 'Fira-sans',
                                  fontWeight: FontWeight.bold))),
                      SizedBox(width: 2 * appConfig.blockSize),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(session.name)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SessionLogScreen(
                                    sessionUid: session.id,
                                    adventureUid: session.adventureUid))),
                        child: Image.asset('assets/adventures/espadas.webp',
                            width: 5 * appConfig.blockSize),
                      ),
                      adminButtons(adventure, session),
                    ],
                  )
                ],
              ),
              SizedBox(height: 1 * appConfig.blockSizeVertical),
            ],
          );
        }).toList(),
      ),
    );
  }
}
