import 'package:flutter/material.dart';

class HidranteDetails extends StatelessWidget {
  final String sigla;
  final String imagem;
  final String endereco;
  final String condicao;
  final String pressao;
  final String vazao;
  final String acesso;
  final String status;
  final String tipo;

  const HidranteDetails({
    Key? key,
    required this.sigla,
    required this.imagem,
    required this.endereco,
    required this.condicao,
    required this.pressao,
    required this.vazao,
    required this.acesso,
    required this.status,
    required this.tipo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String itemCondicao = '';

    if (condicao == 'Boa') {
      itemCondicao = 'Boa';
    }
    if (condicao == 'Seco') {
      itemCondicao = 'Seco';
    }
    if (condicao == 'EM') {
      itemCondicao = 'EM - Emperrado';
    }
    if (condicao == 'ET') {
      itemCondicao = 'ET - Enterrado';
    }
    if (condicao == 'ES') {
      itemCondicao = 'ES - Espanado';
    }
    if (condicao == 'RP') {
      itemCondicao = 'RP - Registro Profundo';
    }
    if (condicao == 'D') {
      itemCondicao = 'D - Desconhecido';
    }

    return Container(
      child: Wrap(
        children: [
          Image.network(
            imagem,
            height: 380,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Text(
                sigla,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              )),
          Row(children: [
            Container(
              padding: EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
              // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
              child: Text(
                "Endereço:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]),
          Row(children: [
            Container(
              padding: EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
              // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
              child: Text(
                endereco,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ]),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  "Pressão:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  pressao,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  "Condição:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  sigla != '' ? itemCondicao : 'Desconhecido',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  "Tipo:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Text(
                  tipo,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                child: Text(
                  "Vazão:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                child: Text(
                  vazao,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                child: Text(
                  "Status:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 10, left: 15, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                child: Text(
                  "Acesso:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(bottom: 10, left: 5, top: 10, right: 0),
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 70),
                child: Text(
                  acesso,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
