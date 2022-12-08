import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_hpg/pages/add_hidrante_page.dart';
import 'package:projeto_hpg/pages/mapa/mapa_page.dart';
import 'package:projeto_hpg/pages/menu_page.dart';

import '../controllers/chip_controller.dart';
import '../controllers/firebase_controller.dart';
import '../models/hidrante_model.dart';
import 'lista_page.dart';
import 'lista_page_pregular.dart';
import 'lista_page_pruim.dart';

class ListaPagePBoa extends StatefulWidget {
  const ListaPagePBoa({super.key});

  @override
  State<ListaPagePBoa> createState() => _ListaPagePBoaState();
}

class _ListaPagePBoaState extends State<ListaPagePBoa> {
  final FirestoreController firestoreController =
      Get.put(FirestoreController());

  final ChipController chipController = Get.put(ChipController());

  final List<String> _chipLabel = ['Todos', 'Boa', 'Regular', 'Ruim'];

  final CollectionReference _hidrantes =
      FirebaseFirestore.instance.collection('hidrantes');

  final TextEditingController _siglaController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _pressaoController = TextEditingController();
  final TextEditingController _vazaoController = TextEditingController();
  final TextEditingController _condicaoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _acessoController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _siglaController.text = documentSnapshot['sigla'];
      _endController.text = documentSnapshot['endereco'];
      _pressaoController.text = documentSnapshot['pressao'];
      _vazaoController.text = documentSnapshot['vazao'];
      _condicaoController.text = documentSnapshot['condicao'];
      _statusController.text = documentSnapshot['status'];
      _tipoController.text = documentSnapshot['tipo'];
      _acessoController.text = documentSnapshot['acesso'];
    }

    void showSnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text('Hidrante editado com sucesso!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Fechar',
          disabledTextColor: Colors.white,
          textColor: Colors.yellow,
          onPressed: () {
            //Do whatever you want
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Wrap(children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5, left: 0, bottom: 15, right: 0),
                      child: RichText(
                          text: TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, right: 10, left: 0),
                              child: Icon(
                                Icons.edit,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: 'Editar hidrante',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _siglaController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.blue)),
                            labelText: 'Sigla'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _endController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.blue)),
                            labelText: 'Endereço'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _pressaoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Pressão'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _vazaoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Vazão'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _condicaoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Condição'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _statusController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Status'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _tipoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Tipo'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _acessoController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blue)),
                                  labelText: 'Acesso'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                  child: const Text('Salvar'),
                                  onPressed: () async {
                                    final String sigla = _siglaController.text;
                                    final String endereco = _endController.text;
                                    final String pressao =
                                        _pressaoController.text;
                                    final String vazao = _vazaoController.text;
                                    final String condicao =
                                        _condicaoController.text;
                                    final String status =
                                        _statusController.text;
                                    final String tipo = _tipoController.text;
                                    final String acesso =
                                        _acessoController.text;
                                    if (endereco != null) {
                                      await _hidrantes
                                          .doc(documentSnapshot!.id)
                                          .update({
                                        "sigla": sigla,
                                        "endereco": endereco,
                                        "pressao": pressao,
                                        "vazao": vazao,
                                        "condicao": condicao,
                                        "status": status,
                                        "tipo": tipo,
                                        "acesso": acesso,
                                      });

                                      _siglaController.text = '';
                                      _endController.text = '';
                                      _pressaoController.text = '';
                                      _vazaoController.text = '';
                                      _condicaoController.text = '';
                                      _statusController.text = '';
                                      _tipoController.text = '';
                                      _acessoController.text = '';

                                      Navigator.pop(context);
                                      showSnackBar(context);
                                    }
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                  child: const Text('Fechar'),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF9E9E9E)),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ]);
        });
  }

  var hidranteList = <HidranteModel>[].obs;

  ChipController _chipController = Get.put(ChipController());

  @override
  Object getHidrantes(HidrantePressao pressao) {
    //using enum class HidrantePressao in switch case
    switch (pressao) {
      case HidrantePressao.TODOS:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaPage(),
          ),
        );
        return ListaPage();

      case HidrantePressao.Boa:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaPagePBoa(),
          ),
        );
        return ListaPagePBoa();

      case HidrantePressao.Regular:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaPagePRegular(),
          ),
        );
        return ListaPagePRegular();

      case HidrantePressao.Ruim:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaPagePRuim(),
          ),
        );
        return ListaPagePRuim();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF44336),
          title: const Text("Lista de hidrantes"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 15),
                    child: RichText(
                        text: TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Icon(
                            Icons.filter_list_alt,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: 'Filtrar por pressão',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    )),
                  ),
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
                              getHidrantes(HidrantePressao
                                  .values[chipController.selectedChip]);
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 8, left: 18),
                    child: Text(
                      'Pressão boa:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('hidrantes')
                          .where('pressao', isEqualTo: 'Boa')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(documentSnapshot['sigla']),
                                  subtitle: Text(documentSnapshot['endereco']),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _update(documentSnapshot))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
