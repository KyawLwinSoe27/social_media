// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media_app/blocs/text_recognition_bloc.dart';
// import 'package:social_media_app/utils/extensions.dart';
// import 'package:social_media_app/widgets/primary_button_view.dart';
//
// class TextRecognitionPage extends StatelessWidget {
//   const TextRecognitionPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => TextRecognitionBloc(),
//       child: Scaffold(
//         body: Column(
//           children: [
//             Consumer<TextRecognitionBloc>(
//               builder: (context, bloc, child) => bloc.chosenImageFile != null
//                   ? SizedBox(
//                       width: 300,
//                       height: 300,
//                       child: Image.file(bloc.chosenImageFile ?? File("")),
//                     )
//                   : Container(),
//             ),
//             Consumer<TextRecognitionBloc>(
//               builder: (context, bloc, child) {
//                 return PrimaryButtonView(
//                   label: 'Detect Text',
//                   onTap: () {
//                     ImagePicker()
//                         .pickImage(source: ImageSource.gallery)
//                         .then((pickedImageFile) async {
//                       var bytes = await pickedImageFile?.readAsBytes();
//                       bloc.onImageChose(File(pickedImageFile?.path ??""), bytes ?? Uint8List(0));
//                     }).catchError((onError) {
//                       showSnackBarWithMessage(context,onError.toString());
//                     });
//                   },
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
