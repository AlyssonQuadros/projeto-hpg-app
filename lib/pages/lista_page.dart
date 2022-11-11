import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_hpg/pages/add_hidrante_page.dart';

import '../controllers/chip_controller.dart';
import '../controllers/firebase_controller.dart';
import '../models/hidrante_model.dart';
import 'mapa/mapa_page.dart';

class ListaPage extends StatelessWidget {
  ListaPage({Key? key}) : super(key: key);

  //dependency injection with getx
  final FirestoreController firestoreController =
      Get.put(FirestoreController());
  final ChipController chipController = Get.put(ChipController());

  //name of chips given as list
  final List<String> _chipLabel = ['Todos', 'Boa', 'Regular', 'Ruim'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Lista de hidrantes"),
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapaPage(),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => Wrap(
                      spacing: 20,
                      children: List<Widget>.generate(4, (int index) {
                        return ChoiceChip(
                          label: Text(_chipLabel[index]),
                          selected: chipController.selectedChip == index,
                          onSelected: (bool selected) {
                            chipController.selectedChip =
                                selected ? index : null;
                            firestoreController.onInit();
                            firestoreController.getHidrantes(HidrantePressao
                                .values[chipController.selectedChip]);
                          },
                        );
                      }),
                    ),
                  ),
                ),
                Obx(() => Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: firestoreController.hidranteList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.fire_hydrant_alt_sharp,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => AddHidrantePage(),
                                  ));
                                },
                                title: Text(
                                    "${firestoreController.hidranteList[index].sigla}"),
                                subtitle: Text(
                                  "Pressão: ${firestoreController.hidranteList[index].pressao}",
                                ),
                              ),
                            );
                          }),
                    )),
              ],
            ),
          ),
        ));
  }
}
