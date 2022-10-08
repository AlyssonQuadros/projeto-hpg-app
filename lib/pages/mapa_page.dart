import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_hpg/controllers/mapa_controller.dart';
import 'package:projeto_hpg/pages/edit_user_page.dart';
import 'package:projeto_hpg/pages/lista_page.dart';
import 'package:projeto_hpg/pages/menu_page.dart';

import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:google_maps_webservice/timezone.dart';
import 'package:google_api_headers/google_api_headers.dart';

final appKey = GlobalKey();
final user = FirebaseAuth.instance.currentUser!;

//ashdkjashd
class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  String googleApikey = "AIzaSyDep9mDaFUm3iFdjNIB5bB_Si6-KrYHEOw";
  String location = "Search Location";
  List<Marker> myMarker = [];
  late GoogleMapController mapController;
  final user = FirebaseAuth.instance.currentUser!;

  late String searchAddr;

  filtro() {
    return SimpleDialog(
      title: Text('Filtrar por Proximidade'),
      children: [
        Obx(
          () => Slider(
            value: MapaController.to.raio.value,
            min: 0,
            max: 10,
            divisions: 10000,
            label: MapaController.to.distancia,
            onChanged: (value) => MapaController.to.raio.value = value,
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(right: 24, top: 24),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () => MapaController.to.filtrarHidrantes(),
        //         child: Text('Filtrar'),
        //       ),
        //       TextButton(onPressed: () => Get.back(), child: Text('Cancelar')),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaController());
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      key: appKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Mapa de Hidrantes'),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(30),
        //   ),
        // ),
        actions: <Widget>[
          Container(
            width: 60,
            child: TextButton(
              child: Icon(
                Icons.filter_list_alt,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) => filtro());
              },
            ),
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
      body: Stack(children: [
        GetBuilder<MapaController>(
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
        Positioned(
            //search input bar
            top: 10,
            child: InkWell(
                onTap: () async {
                  var place = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: googleApikey,
                      mode: Mode.overlay,
                      types: [],
                      strictbounds: false,
                      components: [Component(Component.country, 'np')],
                      //google_map_webservice package
                      onError: (err) {
                        print(err);
                      });

                  if (place != null) {
                    setState(() {
                      location = place.description.toString();
                    });

                    //form google_maps_webservice package
                    final plist = GoogleMapsPlaces(
                      apiKey: googleApikey,
                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                      //from google_api_headers package
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    final lat = geometry.location.lat;
                    final lang = geometry.location.lng;
                    var newlatlang = LatLng(lat, lang);

                    //move map camera to selected place with animation
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: newlatlang, zoom: 17)));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: Text(
                            location,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Icon(Icons.search),
                          dense: true,
                        )),
                  ),
                )))
      ]),
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
        color: Color(0xFF3589EC),
        padding: EdgeInsets.only(
          top: 20 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Logado como: ",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              user.email!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ]),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Editar dados'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EditUserPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_sharp),
              title: const Text('Lista de Hidrantes'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ListaPage(),
                ));
              },
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
