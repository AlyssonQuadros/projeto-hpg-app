import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_hpg/main.dart';

import '../widgets/utils.dart';

class CadastroPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const CadastroPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordControllerValidation = TextEditingController();

  bool _isObscure = true;
  bool _isObscureCon = true;

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
    final erroSenha;
    final textErro = 'As senhas não são iguais';

    final styleTitle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

    return Scaffold(
        body: Container(
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 10),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  "Crie a sua conta:",
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: TextFormField(
                controller: passwordControllerValidation,
                obscureText: _isObscureCon,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirmar Senha',
                    suffixIcon: IconButton(
                        icon: Icon(_isObscureCon
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscureCon = !_isObscureCon;
                          });
                        })),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value != null && value != passwordController.text
                        ? 'As senhas não são iguais'
                        : null,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
              child: Divider(
                color: Colors.grey,
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
                icon: Icon(Icons.arrow_forward_outlined),
                onPressed: cadastrar,
                label: Text("Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          text: 'Já possui uma conta? ',
                          children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: 'Faça login',
                            style: TextStyle(
                                color: Color(0xFF0645AD), fontSize: 18))
                      ])),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future cadastrar() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      String message = 'Este email já está em uso por outro usuário';

      Utils.showSnackBar(message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
