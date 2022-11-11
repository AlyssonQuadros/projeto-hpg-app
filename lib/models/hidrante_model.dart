import 'package:cloud_firestore/cloud_firestore.dart';

class HidranteModel {
  String? sigla;
  String? pressao;
  String? status;

  HidranteModel(this.sigla, this.pressao, this.status);

//Funtion for loading firestore data and conver to model object

  HidranteModel.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild sigla should be exactly same as you given in firebase

    sigla = snapshot.get('sigla');
    pressao = snapshot.get('pressao');
    status = snapshot.get('status');
  }
}

//enum class for better filtering

enum HidrantePressao { TODOS, Boa, Regular, Ruim }
