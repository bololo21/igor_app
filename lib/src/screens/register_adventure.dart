import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/register_adventure_bloc.dart';

class RegisterAdventureScreen extends StatefulWidget {
  @override
  _RegisterAdventureScreenState createState() => _RegisterAdventureScreenState();
}

class _RegisterAdventureScreenState extends State<RegisterAdventureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = $Provider.of<RegisterAdventureBloc>();
  String _imagePath;

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
                        padding: EdgeInsets.fromLTRB(2 * appConfig.blockSize, 1 * appConfig.blockSizeVertical,
                            2 * appConfig.blockSize, 2 * appConfig.blockSizeVertical),
                        margin: EdgeInsets.fromLTRB(
                            2 * appConfig.blockSize, 0, 2 * appConfig.blockSize, 0),
                        //color: const Color(0xffe2e2e1),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[

                              Row(children: <Widget>[
                                GestureDetector(
                                  child: Icon(Icons.close, color: Colors.black12,),
                                  onTap: () => Navigator.pushNamed(context, '/index_adventure'),
                                ),
                                SizedBox(width: 2 * appConfig.blockSize),
                                Text("Criar Aventura",
                                  style: TextStyle(color: Colors.teal),),
                              ],),

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
                                                labelText: 'Nome da Aventura',
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Fira-sans'),
                                                errorText: snapshot.error),
                                          );
                                        }),
                                    StreamBuilder(
                                        stream: _bloc.description,
                                        builder:
                                            (context, AsyncSnapshot<String> snapshot) {
                                          return TextField(
                                            onChanged: _bloc.changeDescription,
                                            decoration: InputDecoration(
                                                labelText: 'Descrição',
                                                labelStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontFamily: 'Fira-sans'),
                                                errorText: snapshot.error),
                                          );
                                        }),
                                    StreamBuilder(
                                        stream: _bloc.imagePath,
                                        builder:
                                            (context, AsyncSnapshot<String> snapshot) {
                                          return new FormField(
                                            builder: (FormFieldState state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  labelText: 'Imagem de Fundo',
                                                ),
                                                isEmpty: _imagePath == '',
                                                child: new DropdownButtonHideUnderline(
                                                  child: new DropdownButton(
                                                    value: _imagePath,
                                                    isDense: true,
                                                    onChanged: (value){
                                                      setState(() {
                                                        _imagePath = value;
                                                      });
                                                      _bloc.changeImagePath(value);
                                                    },
                                                    items: <String>[
                                                      'Coast',
                                                      'Corvali',
                                                      'Heartlands',
                                                      'Krevast',
                                                      'Padrão'
                                                    ].map((String value) {
                                                      return new DropdownMenuItem(
                                                        value: value,
                                                        child: new Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2 * appConfig.blockSizeVertical),
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
                                          _bloc.registerAdventure();
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAdventureScreen(adventureUid: )));
                                          Navigator.pushNamed(context, '/index_adventure');
                                        })
                                  ],
                                ),
                              ),
                              SizedBox(height: 59 * appConfig.blockSizeVertical),
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
    $Provider.dispose<RegisterAdventureBloc>();
    super.dispose();
  }
}
