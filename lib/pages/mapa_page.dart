import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_hpg/controllers/mapa_controller.dart';
import 'package:projeto_hpg/pages/menu_page.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  List<Marker> myMarker = [];
  late GoogleMapController mapController;
  late String searchAddr;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaController());
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Mapa de Hidrantes'),
        actions: <Widget>[
          Container(
            width: 60,
            child: TextButton(
                child: Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
      body: GetBuilder<MapaController>(
        init: controller,
        builder: (value) => GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: controller.position,
            zoom: 13,
          ),
          // onTap: _handleTap,
          // markers: Set.from(myMarker),
          markers: controller.markers,
          myLocationEnabled: true,
          onMapCreated: controller.onMapCreated,
        ),
      ),
    );
  }

  // _handleTap(LatLng tappedPoint) {
  //   setState(() {
  //     myMarker = [];
  //     myMarker.add(Marker(
  //       markerId: MarkerId(tappedPoint.toString()),
  //       position: tappedPoint,
  //     ));
  //   });
  // }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Dados usuário'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MenuPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_sharp),
              title: const Text('Hidrantes'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Agenda'),
              onTap: () {},
            ),
            const Divider(color: Colors.black54),
            ListTile(
                leading: const Icon(Icons.exit_to_app_outlined),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
                }),
          ],
        ),
      );

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
