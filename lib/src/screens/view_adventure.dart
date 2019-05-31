import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/view_adventure_bloc.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/user.dart';
import 'package:igor_app/src/screens/add_user.dart';

import '../../app_config.dart';
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
  String imagePath = 'assets/adventures/andamento.png';
  int aba = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          width: 17 * appConfig.blockSize,
          height: 17 * appConfig.blockSize,
          child: returnButton(),
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
        decoration: new BoxDecoration(color: pickColor(adventure)),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/adventures/${adventure.imagePath}.png"))),
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
                          imagePath = 'assets/adventures/andamento.png';
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
                          imagePath = 'assets/adventures/jogadores.png';
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
              child: Row(
                children: <Widget>[
                  Text("ver mais",
                      style: TextStyle(
                          fontFamily: 'Fira-sans', color: Colors.teal)),
                  Icon(Icons.arrow_drop_down, color: Colors.teal),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Divider(color: Colors.grey[800]),
            ),
            showSessions(adventure),
          ],
        ),
      );
    } else {
      return StreamBuilder(
        stream: _bloc.getUsersInAdventure(widget.adventureUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<User> usersInAdventureList =
                _bloc.mapToUserList(docList: docs);
            return Container(
              height: 33 * appConfig.blockSizeVertical,
              width: 82 * appConfig.blockSize,
              child: ListView(
                children: usersInAdventureList.map((user) {
                  return Column(
                    children: <Widget>[
                      adventure.masterUid == user.id
                          ? Container(
                              alignment: Alignment.topLeft,
                              child: Text(user.username,
                                  style: TextStyle(
                                      fontFamily: 'Fira-sans',
                                      fontWeight: FontWeight.bold)))
                          : Container(
                              alignment: Alignment.topLeft,
                              child: Text(user.username,
                                  style: TextStyle(fontFamily: 'Fira-sans'))),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          } else
            return Text("");
        },
      );
    }
  }

  Widget showSessions(Adventure adventure) {
    return Text("");
  }

  Color pickColor(Adventure adventure) {
    if (adventure.imagePath == 'Coast') {
      return const Color(0xfff9a073);
    } else if (adventure.imagePath == 'Corvali') {
      return const Color(0xff0f857e);
    } else if (adventure.imagePath == 'Heartlands') {
      return const Color(0xff1a3f51);
    } else if (adventure.imagePath == 'Krevast') {
      return const Color(0xff6c203e);
    } else {
      return const Color(0xff1e2843);
    }
  }

  FloatingActionButton returnButton() {
    if (aba == 1) {
      return FloatingActionButton(
        child: Image.asset('assets/adventures/botão_adicionar_sessões.png'),
        onPressed: () => print("adicionar sessões"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    } else {
      return FloatingActionButton(
        child: Image.asset('assets/adventures/botão_adicionar_jogadores.png'),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddUserScreen(adventureUid: widget.adventureUid))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    }
  }
}
