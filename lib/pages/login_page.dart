import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_hpg/main.dart';
import 'package:projeto_hpg/pages/recuperar_senha_page.dart';
import 'package:projeto_hpg/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/gestures/tap.dart';

import '../app_widget.dart';
import '../widgets/utils.dart';
import 'cadastro_page.dart';
import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const btnEntrar = const Color(0xFF3589EC);
    const umid = const Color(0xFF22BF64);
    const background = const Color(0xFF104e67);

    final styleTitle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

    return Scaffold(
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                  width: 300,
                  height: 150,
                  child: Image.asset("assets/logo_hpg022.png")),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 10),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "Entre em sua conta",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      textStyle: styleTitle,
                      // fontStyle: FontStyle.italic,
                      // color: Colors.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Informe um email válido'
                          : null,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Informe uma senha com mais de 6 caracteres'
                      : null,
                ),
              ),
              // Container(
              //   height: 40,
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     child: Text(
              //       'Recuperar senha',
              //       style: TextStyle(
              //         textAlign: TextAlign.right,
              //         fontSize: 20,
              //       ),
              //     ),
              //     onTap: () {},
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 0, left: 40, right: 30),
                child: Container(
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Text(
                      "Recuperar Senha",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Color(0xFF0645AD)),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RecuperarSenhaPage(),
                    )),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    primary: btnEntrar,
                    // primary: Theme.of(context).colorScheme.primary,
                  ),
                  icon: Icon(Icons.login),
                  onPressed: login,
                  label: Text("Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            text: 'Não possui uma conta? ',
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignUp,
                              text: 'Cadastre-se',
                              style: TextStyle(
                                  color: Color(0xFF0645AD), fontSize: 15))
                        ])),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      String message =
          "Email informado não encontrado. Informe um email cadastrado no sistema.";

      Utils.showSnackBar(message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
