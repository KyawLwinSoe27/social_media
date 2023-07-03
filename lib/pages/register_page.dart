import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/register_bloc.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/resources/dimensions.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/label_textfield_view.dart';
import 'package:social_media_app/widgets/page_title_widget_view.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';
import 'package:social_media_app/widgets/text_row_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterBloc(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitleWidgetView(
                titleText: 'Register',
              ),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Profile Picture",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_MEDIUM,
                    ),
                    Consumer<RegisterBloc>(
                      builder: (context, bloc, child) => InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.camera);
                          if(image != null) {
                            bloc.onImageChose(File(image.path));
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(color: Colors.black54)),
                          child: bloc.chooseProfilePicture != null ? Image.file(bloc.chooseProfilePicture ?? File(""),fit: BoxFit.contain, width: 80,height: 80,) : const Icon(
                            Icons.camera_alt_outlined,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<RegisterBloc>(
                builder: (BuildContext context, bloc, Widget? child) =>
                    LabelAndTextFieldView(
                  labelText: 'Email',
                  hintText: 'Please Enter Your Email',
                  onChanged: (val) => bloc.onEmailChange(val),
                ),
              ),
              const SizedBox(
                height: MARGIN_MEDIUM_3,
              ),
              Consumer<RegisterBloc>(
                builder: (BuildContext context, bloc, Widget? child) =>
                    LabelAndTextFieldView(
                  labelText: 'User Name',
                  hintText: 'Please Enter Your User Name',
                  onChanged: (val) => bloc.onUserNameChange(val),
                ),
              ),
              const SizedBox(
                height: MARGIN_MEDIUM_3,
              ),
              Consumer<RegisterBloc>(
                builder: (BuildContext context, bloc, Widget? child) =>
                    LabelAndTextFieldView(
                  labelText: 'Password',
                  hintText: 'Please Enter Your Password',
                  onChanged: (val) => bloc.onPasswordChange(val),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: MARGIN_LARGE, horizontal: MARGIN_LARGE),
                child: Consumer<RegisterBloc>(
                  builder: (BuildContext context, bloc, Widget? child) =>
                      PrimaryButtonView(
                          label: 'Register',
                          onTap: () => bloc
                              .onTapRegister()
                              .then((_) =>
                                  navigateToScreen(context, const LoginPage()))
                              .catchError((error) => showSnackBarWithMessage(
                                  context, error.toString()))),
                ),
              ),
              const Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: TextRow(
                  firstText: "Already have an account?",
                  secondText: "Login",
                  onTap: () => navigateToScreen(context, const LoginPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
