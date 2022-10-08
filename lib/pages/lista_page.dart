import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:footer/footer_view.dart';

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    const btnEntrar = const Color(0xFF104e67);
    const umid = const Color(0xFF22BF64);
    const btnMenu = const Color(0x3589EC);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Lista de Hidrantes'),
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
    );
  }
}
