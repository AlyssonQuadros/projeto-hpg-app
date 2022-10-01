import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_hpg/pages/login_page.dart';
import 'package:projeto_hpg/pages/mapa_page.dart';
import 'package:projeto_hpg/pages/menu_page.dart';
import 'package:projeto_hpg/services/auth_service.dart';
import 'package:projeto_hpg/widgets/auth_check.dart';
import 'package:projeto_hpg/widgets/utils.dart';
import 'package:provider/provider.dart';

import 'app_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'HPG',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Dados incorretos'));
            } else if (snapshot.hasData) {
              return MapaPage();
            } else {
              return AuthService();
            }
          },
        ),
      );

  //   @override
  // Widget build(BuildContext context) {
  //   AuthService auth = Provider.of<AuthService>(context);

  //   if (auth.isLoading)
  //     return loading();
  //   else if (auth.usuario == null)
  //     return LoginPage();
  //   else
  //     return MenuPage();
  // }

  // loading() {
  //   return Scaffold(
  //     body: Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }
}
