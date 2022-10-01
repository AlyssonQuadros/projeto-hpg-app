import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_hpg/pages/cadastro_page.dart';
import 'package:projeto_hpg/pages/login_page.dart';

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(onClickedSignUp: toggle)
      : CadastroPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
