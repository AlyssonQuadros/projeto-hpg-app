import 'package:flutter/material.dart';

class HidranteDetails extends StatelessWidget {
  final String nome;
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
    required this.nome,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        children: [
          Image.network(
            imagem,
            height: 500,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 24, right: 0, bottom: 0),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              nome,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80, left: 0, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Endereço",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 110, left: 24, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              endereco,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 170, left: 0, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Condição",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200, left: 24, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              condicao,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 170, left: 116, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Pressão",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200, left: 140, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              pressao,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 170, left: 236, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Vazão",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200, left: 260, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              vazao,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 240, left: 0, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Acesso",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 270, left: 24, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              acesso,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 240, left: 116, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 270, left: 140, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 310, left: 0, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              "Tipo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 340, left: 24, right: 24, bottom: 24),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              tipo,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
