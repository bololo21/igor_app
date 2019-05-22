import 'package:flutter/material.dart';

import '../../app_config.dart';

class IgorAppBar extends AppBar {
  IgorAppBar({Key key})
      : super(
          key: key,
          iconTheme: IconThemeData(color: Colors.amber[200]),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.more_vert, color: Colors.amber[200]),
                onPressed: () => print('popop'))
          ],
          title: Container(
              child: new Image.asset('assets/navbar/Igor.png',
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
                padding: const EdgeInsets.only(left: 25, right: 25),
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
                            Image.asset('assets/navbar/Aventuras.png',
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
                            Image.asset('assets/navbar/Livros.png',
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
                            Image.asset('assets/navbar/Conta.png',
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
                            Image.asset('assets/navbar/Notificações.png',
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
                            Image.asset('assets/navbar/Configurações.png',
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
                  ],
                ),
              ),
            ));
}
