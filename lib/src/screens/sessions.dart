import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../app_config.dart';
import 'app_bar.dart';
import 'package:igor_app/app_config.dart';

class SessionsScreen extends StatefulWidget {
  final String adventureUid;
  const SessionsScreen({Key key, @required this.adventureUid})
      : super(key: key);
  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IgorAppBar(),
        drawer: IgorDrawer(context),
        body: StreamBuilder(
        stream: loadSessions(widget.adventureUid),
        builder: (context, snapshots) {
        if(snapshots.hasData)
          return Scaffold(
              backgroundColor: const Color(0xfffafafa),
              body: ListView(
                  children: snapshots.data.documents.map<Widget>((session) => 
                  new GestureDetector(
                    child: Container(
                      child: Column(children: <Widget>[
                        SizedBox(height: 5,),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text("Session Name: " + session.data["sessionName"],
                                style: TextStyle(
                                    fontFamily: 'Fira-sans',
                                    color: Colors.green,
                                    fontSize: 24)),
                          ),
                          SizedBox(height: 3 * appConfig.blockSizeVertical),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Session Date: " + session.data["sessionDate"],
                                style: TextStyle(
                                    fontFamily: 'Fira-sans',
                                    color: Colors.green,
                                    fontSize: 24)),
                          ),
                          SizedBox(
                            child: Divider(color: Colors.grey[800]),
                            height: 4 * appConfig.blockSizeVertical),
                          ],
                        ),
                      ),
                    )).toList())
              );
        }));
        }


  loadSessions(id) =>  Firestore.instance.collection("sessions").where("adventureUid", isEqualTo: id).snapshots();
  
}