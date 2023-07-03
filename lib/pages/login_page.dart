import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/login_bloc.dart';
import 'package:social_media_app/pages/news_feed_page.dart';
import 'package:social_media_app/pages/register_page.dart';
import 'package:social_media_app/resources/dimensions.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/label_textfield_view.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/page_title_widget_view.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';
import 'package:social_media_app/widgets/text_row_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginBloc(),
      child: SafeArea(
        child: Selector<LoginBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) => Stack(
            children: [
              Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageTitleWidgetView(
                      titleText: 'Login',
                    ),
                    Consumer<LoginBloc>(
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
                    Consumer<LoginBloc>(
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
                      child: Consumer<LoginBloc>(
                        builder: (context, bloc, child) => PrimaryButtonView(
                          label: 'Login',
                          onTap: () => bloc
                              .onTapLogin()
                              .then((_) => navigateToScreen(
                                  context, const NewsFeedPage()))
                              .catchError((onError) => showSnackBarWithMessage(
                                  context, onError.toString())),
                        ),
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
                        firstText: "Don't have an account?",
                        secondText: "Register",
                        onTap: () =>
                            navigateToScreen(context, const RegisterPage()),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
