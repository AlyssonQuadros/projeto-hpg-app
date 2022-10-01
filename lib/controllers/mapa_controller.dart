import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/db.dart';
import '../widgets/hidrante_details.dart';

class MapaController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  late StreamSubscription<Position> positionStream;
  LatLng _position = LatLng(-25.094704144120772,
      -50.16134946964497); //-25.140434575803752, -50.169471515351454
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static MapaController get to => Get.find<MapaController>();
  get mapsController => _mapsController;
  get position => _position;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadHidrantes();
  }

  loadHidrantes() async {
    FirebaseFirestore db = DB.get();
    final hidrantes = await db.collection('hidrantes').get();

    hidrantes.docs.forEach((hidrante) => addMarker(hidrante));
  }

  addMarker(hidrante) async {
    GeoPoint point = hidrante.get('position.geopoint');

    markers.add(
      Marker(
        markerId: MarkerId(hidrante.id),
        position: LatLng(
          point.latitude,
          point.longitude,
        ),
        infoWindow: InfoWindow(title: hidrante.get('nome')),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              size: Size(200, 200),
            ),
            'assets/fire-hydrant_64.png'),
        onTap: () => showDetails(hidrante.data()),
      ),
    );
    update();
  }

  showDetails(hidrante) {
    Get.bottomSheet(
      HidranteDetails(
        nome: hidrante['nome'],
        imagem: hidrante['imagem'],
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
