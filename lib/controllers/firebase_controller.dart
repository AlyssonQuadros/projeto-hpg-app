import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projeto_hpg/controllers/chip_controller.dart';
import '../models/hidrante_model.dart';

class FirestoreController extends GetxController {
  //referance to firestore collection here hidrantes is collection name
  final CollectionReference _hidranteRef =
      FirebaseFirestore.instance.collection('hidrantes');

  var hidranteList = <HidranteModel>[].obs;

  //dependency injection with getx
  ChipController _chipController = Get.put(ChipController());

  @override
  void onInit() {
    //binding to stream so that we can listen to realtime cahnges

    hidranteList.bindStream(
        getHidrantes(HidrantePressao.values[_chipController.selectedChip]));
    super.onInit();
  }

// this fuction retuns stream of hidrantes list from firestore

  Stream<List<HidranteModel>> getHidrantes(HidrantePressao pressao) {
    //using enum class HidrantePressao in switch case
    switch (pressao) {
      case HidrantePressao.TODOS:
        Stream<QuerySnapshot> stream = _hidranteRef.snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return HidranteModel.fromDocumentSnapshot(snap);
            }).toList());

      case HidrantePressao.Boa:
        Stream<QuerySnapshot> stream =
            _hidranteRef.where('pressao', isEqualTo: 'Boa').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return HidranteModel.fromDocumentSnapshot(snap);
            }).toList());

      case HidrantePressao.Regular:
        Stream<QuerySnapshot> stream =
            _hidranteRef.where('pressao', isEqualTo: 'Regular').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return HidranteModel.fromDocumentSnapshot(snap);
            }).toList());

      case HidrantePressao.Ruim:
        Stream<QuerySnapshot> stream =
            _hidranteRef.where('pressao', isEqualTo: 'Ruim').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return HidranteModel.fromDocumentSnapshot(snap);
            }).toList());
    }
  }
}
