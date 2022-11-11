import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_hpg/pages/Mapa/mapa_page_pboa.dart';
import '../database/db.dart';
import '../widgets/hidrante_details.dart';
import '../widgets/hidrante_detalhes.dart';

class MapaControllerPBoa extends GetxController {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final raio = 0.0.obs;

  late StreamSubscription<Position> positionStream;
  LatLng _position = LatLng(-25.094704144120772,
      -50.16134946964497); //-25.140434575803752, -50.169471515351454
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static MapaControllerPBoa get to => Get.find<MapaControllerPBoa>();
  get mapsController => _mapsController;
  get position => _position;
  String get distancia => raio.value < 1
      ? '${(raio.value * 1000).toStringAsFixed(0)} m'
      : '${(raio.value).toStringAsFixed(0)} km';

  // filtrarHidrantes() {
  //   final geo = Geoflutterfire();
  //   final db = DB.get();

  //   GeoFirePoint center = geo.point(
  //     latitude: latitude.value,
  //     longitude: longitude.value,
  //   );

  //   CollectionReference ref = db.collection('hidrantes');

  //   String field = 'position';

  //   Stream<List<DocumentSnapshot>> stream = geo
  //       .collection(collectionRef: ref)
  //       .within(center: center, radius: raio.value, field: field);

  //   stream.listen((List<DocumentSnapshot> hidrantes) {
  //     markers.clear();
  //     hidrantes.forEach((hidrante) {
  //       addMarker(hidrante);
  //       update();
  //     });
  //     Get.back();
  //   });
  // }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadHidrantesBoa();
  }

  loadHidrantesAll() async {
    // FirebaseFirestore db = DB.get();
    // final hidrantes = await db.collection('hidrantes').get();

    // hidrantes.docs.forEach((hidrante) => addMarker(hidrante));

    final CollectionReference _hidranteRef =
        FirebaseFirestore.instance.collection('hidrantes');

    final hidrantes = await _hidranteRef.get();

    hidrantes.docs.forEach((hidrante) => addMarker(hidrante));
  }

  loadHidrantesBoa() async {
    // FirebaseFirestore db = DB.get();
    // final hidrantes = await db.collection('hidrantes').get();

    // hidrantes.docs.forEach((hidrante) => addMarker(hidrante));

    final CollectionReference _hidranteRef =
        FirebaseFirestore.instance.collection('hidrantes');

    // Stream<QuerySnapshot> stream =
    //     _hidranteRef.where('pressao', isEqualTo: 'Boa').snapshots();
    // return stream.map((snapshot) => snapshot.docs.map((snap) {
    //       return HidranteModel.fromDocumentSnapshot(snap);
    //     }).toList());

    final hidrantes =
        await _hidranteRef.where('pressao', isEqualTo: 'Boa').get();

    hidrantes.docs.forEach((hidrante) => addMarker(hidrante));
  }

  addMarker(hidrante) async {
    GeoPoint point = hidrante.get('position.geopoint');
    String myIcon = 'assets/fire-hydrant_64-vermelho.png';

    markers.add(
      Marker(
        markerId: MarkerId(hidrante.id),
        position: LatLng(
          point.latitude,
          point.longitude,
        ),
        infoWindow: InfoWindow(
            title: hidrante.get('sigla'), snippet: hidrante.get('endereco')),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(200, 200),
            ),
            // hidrante['sigla'] != null
            //     ? showIcon(hidrante, myIcon)
            //     : 'assets/fire-hydrant_64-vermelho.png'),
            'assets/fire-hydrant_64-verde.png'),
        onTap: () => {
          showModalBottomSheet(
            context: appKeyBoa.currentState!.context,
            builder: (context) => HidranteDetails(
              sigla: hidrante['sigla'],
              imagem: hidrante['imagem'],
              endereco: hidrante['endereco'],
              condicao: hidrante['condicao'],
              pressao: hidrante['pressao'],
              vazao: hidrante['vazao'],
              acesso: hidrante['acesso'],
              status: hidrante['status'],
              tipo: hidrante['tipo'],
            ),
          )
        },
      ),
    );

    update();
  }

  showIcon(hidrante, myIcon) async {
    if (hidrante['pressao'] == 'Boa') {
      myIcon = 'assets/fire-hydrant_64-verde.png';
    } else if (hidrante['pressao'] == 'Regular') {
      myIcon = 'assets/fire-hydrant_64-amarelo';
    } else if (hidrante['pressao'] == 'Ruim') {
      myIcon = 'assets/fire-hydrant_64-vermelho.png';
    } else {
      myIcon = 'assets/fire-hydrant_64-vermelho.png';
    }

    if (hidrante['status'] == 'Manutenção') {
      myIcon = 'assets/fire-hydrant_64-roxo.png';
    }

    if (hidrante['tipo'] == 'Recalque') {
      myIcon = 'assets/fire-hydrant_64-azul.png';
    }
  }

  showDetails(hidrante) {
    Get.bottomSheet(
      HidranteDetails(
        sigla: hidrante['sigla'],
        imagem: hidrante['imagem'],
        endereco: hidrante['endereco'],
        condicao: hidrante['condicao'],
        pressao: hidrante['pressao'],
        vazao: hidrante['vazao'],
        acesso: hidrante['acesso'],
        status: hidrante['status'],
        tipo: hidrante['tipo'],
      ),
      barrierColor: Colors.transparent,
    );
  }

  watchPosicao() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilidade a localização do smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[900],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
