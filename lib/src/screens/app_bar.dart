import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/login_bloc.dart';

import '../../app_config.dart';

final _bloc = $Provider.of<LoginBloc>();

class IgorAppBar extends AppBar {
  IgorAppBar({Key key})
      : super(
          key: key,
          iconTheme: IconThemeData(color: Colors.amber[200]),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.more_vert, color: Colors.amber[200]),
                onPressed: () => print('pipip'))
          ],
          title: Container(
              child: new Image.asset('assets/log_in/Igor.webp',
                  fit: BoxFit.cover, width: 20 * appConfig.blockSize)),
          centerTitle: true,
          backgroundColor: const Color(0xff221233),
        );
}

class IgorDrawer extends Drawer {
  IgorDrawer(BuildContext context, {Key key})
      : super(
            key: key,
            child: Container(
              color: const Color(0xff221233),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 35),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10 * appConfig.blockSizeVertical),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/index_adventure'),
                      child: Container(
                        color: Colors.transparent,
                        width: 100 * appConfig.blockSize,
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/navbar/Aventuras.webp',
                                height: 5 * appConfig.blockSizeVertical,
                                width: 5 * appConfig.blockSizeVertical),
                            SizedBox(width: 4 * appConfig.blockSize),
                            Text("Aventuras",
                                style:
                                    TextStyle(color: const Color(0xffff3d55))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * appConfig.blockSizeVertical),
                    GestureDetector(
                      onTap: () => print(
                          "Livros"), //Navigator.pushNamed(context, '/index_book'),
                      child: Container(
                        color: Colors.transparent,
                        width: 100 * appConfig.blockSize,
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/navbar/Livros.webp',
                                height: 5 * appConfig.blockSizeVertical,
                                width: 5 * appConfig.blockSizeVertical),
                            SizedBox(width: 4 * appConfig.blockSize),
                            Text("Livros",
                                style:
                                    TextStyle(color: const Color(0xffff3d55))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * appConfig.blockSizeVertical),
                    GestureDetector(
                      onTap: () => print(
                          "Conta"), //Navigator.pushNamed(context, '/view_user'),
                      child: Container(
                        color: Colors.transparent,
                        width: 100 * appConfig.blockSize,
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/navbar/Conta.webp',
                                height: 5 * appConfig.blockSizeVertical,
                                width: 5 * appConfig.blockSizeVertical),
                            SizedBox(width: 4 * appConfig.blockSize),
                            Text("Conta",
                                style:
                                    TextStyle(color: const Color(0xffff3d55))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * appConfig.blockSizeVertical),
                    GestureDetector(
                      onTap: () => print(
                          "Notificações"), //Navigator.pushNamed(context, '/index_notification'),
                      child: Container(
                        color: Colors.transparent,
                        width: 100 * appConfig.blockSize,
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/navbar/Notificações.webp',
                                height: 5 * appConfig.blockSizeVertical,
                                width: 5 * appConfig.blockSizeVertical),
                            SizedBox(width: 4 * appConfig.blockSize),
                            Text("Notificações",
                                style:
                                    TextStyle(color: const Color(0xffff3d55))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3 * appConfig.blockSizeVertical),
                    GestureDetector(
                      onTap: () => print(
                          "Configurações"), //Navigator.pushNamed(context, '/index_configuration'),
                      child: Container(
                        color: Colors.transparent,
                        width: 100 * appConfig.blockSize,
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/navbar/Configurações.webp',
                                height: 5 * appConfig.blockSizeVertical,
                                width: 5 * appConfig.blockSizeVertical),
                            SizedBox(width: 4 * appConfig.blockSize),
                            Text("Configurações",
                                style:
                                    TextStyle(color: const Color(0xffff3d55))),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                      child: Text("logout",
                                          style: TextStyle(
                                              color: const Color(0xffff3d55),
                                              fontFamily: 'Fira-sans')),
                                      onPressed: () {
                                        _bloc.logOut();
                                        return Navigator.pushNamed(context, '/log_in');
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ));
}
