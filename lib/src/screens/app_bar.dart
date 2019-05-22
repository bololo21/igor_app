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
              child: new Image.asset('assets/navbar/igor.png',
                  fit: BoxFit.cover, width: 20 * appConfig.blockSize)),
          centerTitle: true,
          backgroundColor: const Color(0xff221233),
        );
}

class IgorDrawer extends Drawer {
  IgorDrawer({Key key})
      : super(
    key: key,
    child: Container(
      color: const Color(0xff221233),
      child: Column(children: <Widget>[
          Row(children: <Widget>[
        Image.asset('assets/navbar/Aventuras.png'),
        Text("Aventuras", style: TextStyle(color: const Color(0xffff3d55))),
          ],),
      ],),
    )
  );
}
