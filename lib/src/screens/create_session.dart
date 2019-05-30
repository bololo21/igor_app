import 'package:flutter/material.dart';
import 'dart:async';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/create_session_bloc.dart';
import 'package:intl/intl.dart';

class RegisterSessionScreen extends StatefulWidget {
  @override
  _RegisterSessionScreenState createState() => _RegisterSessionScreenState();
}

class _RegisterSessionScreenState extends State<RegisterSessionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = $Provider.of<CreateSessionBloc>();
  
  @override
  Widget build(BuildContext context) {
    appConfig.setConfig(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/log_in/Backgrownd.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 10 * appConfig.blockSizeVertical,
              ),
              Container(
                decoration: new BoxDecoration(
                    color: const Color(0xffe2e2e1),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0))),
                padding: EdgeInsets.fromLTRB(
                    2 * appConfig.blockSize,
                    1 * appConfig.blockSizeVertical,
                    2 * appConfig.blockSize,
                    2 * appConfig.blockSizeVertical),
                margin: EdgeInsets.fromLTRB(
                    2 * appConfig.blockSize, 0, 2 * appConfig.blockSize, 0),
                //color: const Color(0xffe2e2e1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: Colors.black12,
                            ),
                            onTap: () => Navigator.pushNamed(
                                context, '/index_adventure'),
                          ),
                          SizedBox(width: 2 * appConfig.blockSize),
                          Text(
                            "Criar Sessão",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            StreamBuilder(
                                stream: _bloc.name,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    onChanged: _bloc.changeName,
                                    decoration: InputDecoration(
                                        labelText:
                                            'De um nome à próxima sessão',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 3 * appConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                                child: Text("DATA"),
                                textColor: const Color(0xffe2e2e1),
                                color: Colors.teal,
                                onPressed: () {
                                  _selectDate(context);
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            MaterialButton(
                                child: Text("PRONTO"),
                                textColor: const Color(0xffe2e2e1),
                                color: Colors.teal,
                                onPressed: () {
                                  _bloc.createSession();
                                  Navigator.pushNamed(
                                      context, '/index_adventure');
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        )
      ],
    ));
  }

  @override
  void dispose() {
    $Provider.dispose<CreateSessionBloc>();
    super.dispose();
  }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2020),
    );
    if (picked != null) {
      //DateTime _date;
  //String _dateFormated = DateFormat('dd/MM').format(_date);
      String _dateFormated =  DateFormat('dd/MM/yyyy').format(picked);
      _bloc.changeDate(_dateFormated.toString());
    }
  }
}