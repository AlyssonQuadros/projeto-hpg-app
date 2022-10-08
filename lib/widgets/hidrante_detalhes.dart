// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';

// class HidranteDetalhes extends StatelessWidget {
//   Hidrante hidrante;

//   HidranteDetalhes({Key? key, required this.hidrante}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Wrap(
//         children: [
//           Image.network(
//             hidrante.imagem,
//             height: 250,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 24, left: 24),
//             child: Text(
//               hidrante.nome,
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
