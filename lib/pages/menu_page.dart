import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'mapa_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    const btnEntrar = const Color(0xFF104e67);
    const umid = const Color(0xFF22BF64);
    const btnMenu = const Color(0x3589EC);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Menu'),
        actions: <Widget>[
          Container(
            width: 60,
            child: TextButton(
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
      body: FooterView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Logado como: ",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                user.email!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapaPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Mapa',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3589EC)),
                        minimumSize: MaterialStateProperty.all(Size(220, 60))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Hidrantes',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3589EC)),
                        minimumSize: MaterialStateProperty.all(Size(220, 60))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Agenda',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3589EC)),
                        minimumSize: MaterialStateProperty.all(Size(220, 60))),
                  ),
                ),
              ],
            ),
          ),
        ],
        footer: Footer(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Copyright ©2022, All Rights Reserved.',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0,
                    color: Color(0xFFFFFFFF)),
              ),
            ),
            Text(
              'Powered by Nexsport',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                  color: Color(0xFFFFFFFF)),
            ),
          ]),
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.red,
        ),
        flex: 2, //default flex is 2
      ),
    );
  }
}
