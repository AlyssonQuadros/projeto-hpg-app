import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_hpg/pages/lista_page.dart';
import 'mapa/mapa_page.dart';

class AddHidrantePage extends StatefulWidget {
  const AddHidrantePage({super.key});

  @override
  State<AddHidrantePage> createState() => _AddHidrantePageState();
}

class _AddHidrantePageState extends State<AddHidrantePage> {
  CollectionReference hidrantes =
      FirebaseFirestore.instance.collection('hidrantes');

  final _formKey = GlobalKey<FormState>();
  final List<String> selectCondicao = ['Boa', 'Regular', 'Ruim'];
  final List<String> selectPressao = ['Boa', 'Regular', 'Ruim'];
  final List<String> selectVazao = ['Boa', 'Regular', 'Ruim'];
  final List<String> selectAcesso = ['Boa', 'Regular', 'Ruim'];
  final List<String> selectStatus = ['Boa', 'Regular', 'Ruim'];
  final List<String> selectTipo = ['Boa', 'Regular', 'Ruim'];

  // form values
  late String _condicao = 'Boa';
  late String _pressao = 'Boa';
  late String _vazao = 'Boa';
  late String _acesso = 'Boa';
  late String _status = 'Boa';
  late String _tipo = 'Boa';
  GeoPoint? _position;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    const btnEntrar = const Color(0xFF3589EC);
    const umid = const Color(0xFF22BF64);
    const btnMenu = const Color(0x3589EC);

    List<String> condicaoItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemCondicao = 'Boa';

    List<String> pressaoItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemPressao = 'Boa';

    List<String> vazaoItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemVazao = 'Boa';

    List<String> acessoItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemAcesso = 'Boa';

    List<String> statusItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemStatus = 'Boa';

    List<String> tipoItems = ['Boa', 'Regular', 'Ruim'];
    String? selectedItemTipo = 'Boa';

    String sigla = '';
    String imagem = '';
    String endereco = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Adicionar Hidrante"),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListaPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onChanged: (value) {
                  sigla = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 3, color: Colors.blue)),
                    hintText: 'Sigla'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onChanged: (value) {
                  imagem = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 3, color: Colors.blue)),
                    hintText: 'Link da imagem'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onChanged: (value) {
                  endereco = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 3, color: Colors.blue)),
                    hintText: 'Endereço'),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: 180,
            //       child: Padding(
            //         padding: const EdgeInsets.all(15),
            //         child: TextFormField(
            //           onChanged: (_position) {
            //             _position;
            //           },
            //           decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(12),
            //                   borderSide:
            //                       BorderSide(width: 3, color: Colors.blue)),
            //               hintText: 'Latitude'),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 180,
            //       child: Padding(
            //         padding: const EdgeInsets.all(15),
            //         child: TextFormField(
            //           onChanged: (_position) {
            //             _position;
            //           },
            //           decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(12),
            //                   borderSide:
            //                       BorderSide(width: 3, color: Colors.blue)),
            //               hintText: 'Longitude'),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Condição',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _condicao,
                      items: selectCondicao.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _condicao = val!),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Pressão',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _pressao,
                      items: selectPressao.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _pressao = val!),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Vazão',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _vazao,
                      items: selectVazao.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _vazao = val!),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Acesso',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _acesso,
                      items: selectAcesso.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _acesso = val!),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Status',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _status,
                      items: selectStatus.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _status = val!),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue)),
                        labelText: 'Tipo',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      value: _tipo,
                      items: selectTipo.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _tipo = val!),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 30),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  primary: btnEntrar,
                  // primary: Theme.of(context).colorScheme.primary,
                ),
                icon: Icon(Icons.save),
                onPressed: () async {
                  await hidrantes.add({
                    'sigla': sigla,
                    'imagem': imagem,
                    'endereco': endereco,
                    'condicao': _condicao,
                    'pressao': _pressao,
                    'vazao': _vazao,
                    'acesso': _acesso,
                    'status': _status,
                    'tipo': _tipo,
                    // 'position': point.data
                  }).then((value) => print('hidrante adicionado'));
                },
                label: Text("Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
