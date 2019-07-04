import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/invites_bloc.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/invite.dart';
import 'package:igor_app/src/models/user.dart';
import '../../app_config.dart';
import 'app_bar.dart';

class IndexInvitesScreen extends StatefulWidget {
  @override
  _IndexInvitesScreenState createState() => _IndexInvitesScreenState();
}

class _IndexInvitesScreenState extends State<IndexInvitesScreen> {
  final _bloc = $Provider.of<InvitesBloc>();

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
              builder: (context, currentUserSnapshot) {
                if (currentUserSnapshot.hasData) {
                  return StreamBuilder(
                      stream: _bloc.getUserData(currentUserSnapshot.data.uid),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.hasData) {
                          User currentUser =
                              _bloc.mapToUser(document: userSnapshot.data);
                          return StreamBuilder(
                            stream:
                                _bloc.getInvites(currentUserSnapshot.data.uid),
                            builder: (context, invitesSnapshot) {
                              if (invitesSnapshot.hasData) {
                                List<DocumentSnapshot> docs =
                                    invitesSnapshot.data.documents;
                                List<Invite> invitesList =
                                    _bloc.mapToInviteList(docList: docs);
                                return buildList(invitesList, currentUser);
                              } else
                                return Text("Carregando...",
                                    style: TextStyle(
                                        fontFamily: 'Fira-sans',
                                        color: const Color(0xffe2e2e1)));
                            },
                          );
                        } else {
                          return Text("Carregando...",
                              style: TextStyle(
                                  fontFamily: 'Fira-sans',
                                  color: const Color(0xffe2e2e1)));
                        }
                      });
                } else
                  return Text("Carregando...",
                      style: TextStyle(
                          fontFamily: 'Fira-sans',
                          color: const Color(0xffe2e2e1)));
              }),
        ));
  }

  Widget buildList(List<Invite> invitesList, User currentUser) {
    if (invitesList.isEmpty) {
      return Text(
        "Você não possui convites :(",
        style: TextStyle(color: const Color(0xffe2e2e1)),
      );
    } else {
      return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              Divider(color: Colors.transparent, height: 3),
          itemCount: invitesList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: StreamBuilder(
                  stream:
                      _bloc.getAdventureData(invitesList[index].adventureUid),
                  builder: (context, adventureSnapshot) {
                    if (adventureSnapshot.hasData) {
                      Adventure adventure = _bloc.mapToAdventure(
                          document: adventureSnapshot.data);
                      return StreamBuilder(
                          stream: _bloc.getUserData(adventure.masterUid),
                          builder: (context, masterSnapshot) {
                            if (masterSnapshot.hasData) {
                              User master = _bloc.mapToUser(
                                  document: masterSnapshot.data);
                              return inviteCard(adventure, master, currentUser,
                                  invitesList[index].inviteUid);
                            } else
                              return Text("Carregando...",
                                  style: TextStyle(
                                      fontFamily: 'Fira-sans',
                                      color: const Color(0xffe2e2e1)));
                          });
                    } else
                      return Text("Carregando...",
                          style: TextStyle(
                              fontFamily: 'Fira-sans',
                              color: const Color(0xffe2e2e1)));
                  }),
            );
          });
    }
  }

  @override
  void dispose() {
    $Provider.dispose<InvitesBloc>();
    super.dispose();
  }

  Widget inviteCard(
      Adventure adventure, User master, User currentUser, String inviteUid) {
    return Stack(
      children: <Widget>[
        Container(
          height: 20 * appConfig.blockSizeVertical,
          width: 100 * appConfig.blockSize,
          color: Colors.teal,
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
                      child: Text(adventure.name,
                          style: TextStyle(
                              fontFamily: 'Fira-sans',
                              color: const Color(0xffe2e2e1),
                              fontSize: 24)),
                    ),
                    SizedBox(height: 5 * appConfig.blockSizeVertical),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("(mestre:  ${master.username})",
                          style: TextStyle(
                              fontFamily: 'Fira-sans',
                              color: const Color(0xffe2e2e1),
                              fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 2 * appConfig.blockSize,
          top: 2 * appConfig.blockSizeVertical,
          child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _bloc.addUserToAdventure(currentUser, adventure.id, master);
                _bloc.deleteInvite(inviteUid);
                setState(() {});
              }),
        ),
        Positioned(
            right: 2 * appConfig.blockSize,
            bottom: 2 * appConfig.blockSizeVertical,
            child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _bloc.deleteInvite(inviteUid);
                  setState(() {});
                }))
      ],
    );
  }
}
