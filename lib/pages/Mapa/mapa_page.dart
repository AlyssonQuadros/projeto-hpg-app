import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_hpg/controllers/mapa_controller.dart';
import 'package:projeto_hpg/pages/Mapa/mapa_page_pboa.dart';
import 'package:projeto_hpg/pages/edit_user_page.dart';
import 'package:projeto_hpg/pages/lista_page.dart';
import 'package:projeto_hpg/pages/menu_page.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../add_hidrante_page.dart';
import 'mapa_page_pregular.dart';
import 'mapa_page_pruim.dart';

final appKey = GlobalKey();
final user = FirebaseAuth.instance.currentUser!;

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _MapaPageState extends State<MapaPage> {
  String googleApikey = "AIzaSyDep9mDaFUm3iFdjNIB5bB_Si6-KrYHEOw";
  String location = "Procurar endereço...";
  List<Marker> myMarker = [];
  late GoogleMapController mapController;
  final user = FirebaseAuth.instance.currentUser!;
  String icon = 'assets/fire-hydrant_64-vermelho.png';

  late String searchAddr;

  final Mode _mode = Mode.overlay;

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  legenda() {
    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          'Legenda',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23),
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 10, left: 30),
                  child: Image.asset(
                    "assets/fire-hydrant_64-verde.png",
                    width: 30,
                  ),
                ),
              ),
              TextSpan(
                text: 'Pressão boa',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 10, left: 30),
                  child: Image.asset(
                    "assets/fire-hydrant_64-amarelo.png",
                    width: 30,
                  ),
                ),
              ),
              TextSpan(
                text: 'Pressão regular',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 10, left: 30),
                  child: Image.asset(
                    "assets/fire-hydrant_64-vermelho.png",
                    width: 30,
                  ),
                ),
              ),
              TextSpan(
                text: 'Pressão ruim',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 10, left: 30),
                  child: Image.asset(
                    "assets/fire-hydrant_64-roxo.png",
                    width: 30,
                  ),
                ),
              ),
              TextSpan(
                text: 'Em manutenção',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 10, left: 30),
                  child: Image.asset(
                    "assets/fire-hydrant_64-azul.png",
                    width: 30,
                  ),
                ),
              ),
              TextSpan(
                text: 'Hidrante de recalque',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          )),
        )
      ],
    );
  }

  filtro() {
    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          'Filtrar por pressão',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23),
        ),
      ),
      children: [
        // Obx(
        //   () => Slider(
        //     value: MapaController.to.raio.value,
        //     min: 0,
        //     max: 10,
        //     divisions: 10000,
        //     label: MapaController.to.distancia,
        //     onChanged: (value) => MapaController.to.raio.value = value,
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Todos',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF3589EC)),
                      minimumSize: MaterialStateProperty.all(Size(180, 50))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaPagePBoa(),
                      ),
                    );
                  },
                  label: Text(
                    'Boa',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3589EC)),
                  ),
                  icon: Image.asset(
                    'assets/fire-hydrant_64-verde.png',
                    width: 30,
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                            color: Color(0xFF3589EC),
                            width: 1.5,
                          ))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      minimumSize: MaterialStateProperty.all(Size(180, 50))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaPagePRegular(),
                      ),
                    );
                  },
                  label: Text(
                    'Regular',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3589EC)),
                  ),
                  icon: Image.asset(
                    'assets/fire-hydrant_64-amarelo.png',
                    width: 30,
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                            color: Color(0xFF3589EC),
                            width: 1.5,
                          ))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      minimumSize: MaterialStateProperty.all(Size(180, 50))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapaPagePRuim(),
                      ),
                    );
                  },
                  label: Text(
                    'Ruim',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3589EC)),
                  ),
                  icon: Image.asset(
                    'assets/fire-hydrant_64-vermelho.png',
                    width: 30,
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                            color: Color(0xFF3589EC),
                            width: 1.5,
                          ))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      minimumSize: MaterialStateProperty.all(Size(180, 50))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapaController());
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 30, right: 0, left: 0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => filtro());
          },
          backgroundColor: Colors.indigoAccent,
          child: const Icon(Icons.filter_list_alt, size: 30),
        ),
      ),
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
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) => legenda());
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
            onTap: _handleTap,
            // markers: Set.from(myMarker),
            markers: controller.markers,
            myLocationEnabled: true,
            onMapCreated: controller.onMapCreated,
          ),
        ),
        // ElevatedButton(
        //     onPressed: _handlePressButton,
        //     child: const Text("Procurar endereço...")),
        Positioned(
            //search input bar
            top: 0,
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
                  padding:
                      EdgeInsets.only(top: 8, right: 15, left: 15, bottom: 15),
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 80,
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

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleApikey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "br")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: googleApikey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }
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
            // ListTile(
            //   leading: const Icon(Icons.add_location),
            //   title: const Text('Adicionar Hidrante'),
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //       builder: (context) => AddHidrantePage(),
            //     ));
            //   },
            // ),
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
