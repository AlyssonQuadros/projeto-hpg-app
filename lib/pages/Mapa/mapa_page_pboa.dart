import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_hpg/controllers/mapa_controller_pboa.dart';
import 'package:projeto_hpg/pages/edit_user_page.dart';
import 'package:projeto_hpg/pages/lista_page.dart';
import 'package:page_transition/page_transition.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:projeto_hpg/pages/lista_page_pboa.dart';

import 'mapa_page_pregular.dart';
import 'mapa_page_pruim.dart';
import 'mapa_page.dart';

import 'api/api_key.dart';

final appKeyBoa = GlobalKey();
final user = FirebaseAuth.instance.currentUser!;

class MapaPagePBoa extends StatefulWidget {
  const MapaPagePBoa({Key? key}) : super(key: key);

  @override
  State<MapaPagePBoa> createState() => _MapaPagePBoaState();
}

final homeScaffoldKeyBoa = GlobalKey<ScaffoldState>();

class _MapaPagePBoaState extends State<MapaPagePBoa> {
  GoogleMapController? mapController;
  String location = "Procurar...";
  List<Marker> myMarker = [];
  final user = FirebaseAuth.instance.currentUser!;
  String icon = 'assets/fire-hydrant_64-vermelho.png';

  late String searchAddr;

  final Mode _mode = Mode.overlay;

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool customDialRoot = true;
  bool extend = false;
  bool rmIcons = false;

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
                      PageTransition(
                          child: const MapaPage(),
                          type: PageTransitionType.fade),
                    );
                  },
                  child: Text(
                    'Todos',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3589EC)),
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
                      PageTransition(
                          child: const MapaPagePBoa(),
                          type: PageTransitionType.fade),
                    );
                  },
                  label: Text(
                    'Boa',
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
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
                      PageTransition(
                          child: const MapaPagePRegular(),
                          type: PageTransitionType.fade),
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
                      PageTransition(
                          child: const MapaPagePRuim(),
                          type: PageTransitionType.fade),
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
    final controller = Get.put(MapaControllerPBoa());
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SpeedDial(
          icon: Icons.keyboard_arrow_up_sharp,
          activeIcon: Icons.keyboard_arrow_down_sharp,
          spacing: 3,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          buttonSize:
              Size.fromRadius(35), // SpeedDial size which defaults to 56 itself
          // iconTheme: IconThemeData(size: 22),
          label: extend
              ? const Text("Open")
              : null, // The label of the main button.
          activeLabel: extend ? const Text("Close") : null,
          childrenButtonSize: Size.fromRadius(35),
          visible: true,
          direction: SpeedDialDirection.up,
          switchLabelPosition: false,
          closeManually: false,
          renderOverlay: true,
          onOpen: () => debugPrint('OPENING DIAL'),
          onClose: () => debugPrint('DIAL CLOSED'),
          useRotationAnimation: true,
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          animationDuration: const Duration(milliseconds: 400),
          children: [
            SpeedDialChild(
              child: !rmIcons ? const Icon(Icons.filter_alt_off) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Todos',
              visible: true,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: const MapaPage(), type: PageTransitionType.fade),
                );
              },
            ),
            SpeedDialChild(
              child: !rmIcons
                  ? Image.asset(
                      'assets/fire-hydrant_64-verde.png',
                      width: 30,
                    )
                  : null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Boa',
              visible: true,
              onTap: () {},
            ),
            SpeedDialChild(
              child: !rmIcons
                  ? Image.asset(
                      'assets/fire-hydrant_64-amarelo.png',
                      width: 30,
                    )
                  : null,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              label: 'Regular',
              visible: true,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: const MapaPagePRegular(),
                      type: PageTransitionType.fade),
                );
              },
            ),
            SpeedDialChild(
              child: !rmIcons
                  ? Image.asset(
                      'assets/fire-hydrant_64-vermelho.png',
                      width: 30,
                    )
                  : null,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              label: 'Ruim',
              visible: true,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: const MapaPagePRuim(),
                      type: PageTransitionType.fade),
                );
              },
            ),
            SpeedDialChild(
              child: !rmIcons ? const Icon(Icons.list_alt_sharp) : null,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              label: 'Todos',
              visible: true,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      child: const ListaPagePBoa(),
                      type: PageTransitionType.fade),
                );
              },
            ),
          ],
        ),
      ),
      key: appKeyBoa,
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Mapa de Hidrantes'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
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
        GetBuilder<MapaControllerPBoa>(
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

    displayPrediction(p!, homeScaffoldKeyBoa.currentState);
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

    // homeScaffoldKeyBoa.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
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
                  builder: (context) => EditUserPage(
                    onClickedSignIn: () {},
                  ),
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
