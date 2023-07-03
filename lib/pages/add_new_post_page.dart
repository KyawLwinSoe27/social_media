import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/add_new_post_bloc.dart';
import 'package:social_media_app/resources/dimensions.dart';
import 'package:social_media_app/resources/strings.dart';
import 'package:social_media_app/viewitems/post_item_view.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class AddNewPostPage extends StatelessWidget {
  final int? newsFeedId;
  const AddNewPostPage({Key? key, this.newsFeedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AddNewPostBloc(newsFeedId: newsFeedId),
      child: Selector<AddNewPostBloc, bool>(
        selector: (context, bloc) => bloc.isLoading,
        builder: (context, isLoading, child) => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: false,
                title: Text(
                  newsFeedId != null ? "Edit Post" : "Add New Post",
                  style: const TextStyle(color: Colors.black),
                ),
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                      size: MARGIN_XLARGE,
                    )),
                elevation: 0.0,
              ),
              body: Container(
                margin: const EdgeInsets.only(
                  top: MARGIN_XLARGE,
                ),
                padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Consumer<AddNewPostBloc>(
                              builder: (context, bloc, widget) =>
                                  ProfileImageView(
                                    profileImage: bloc.profilePicture,
                                  )),
                          const SizedBox(
                            width: MARGIN_MEDIUM,
                          ),
                          Consumer<AddNewPostBloc>(
                            builder: (context, bloc, widget) =>
                                Text(bloc.userName),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const AddNewPostTextFieldView(),
                      const SizedBox(
                        height: MARGIN_MEDIUM_2,
                      ),
                      const PostErrorWidget(),
                      const SizedBox(
                        height: MARGIN_MEDIUM_2,
                      ),
                      const PostImageWidget(),
                      const SizedBox(
                        height: MARGIN_MEDIUM_2,
                      ),
                      const PostButtonView(),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                    ],
                  ),
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, bloc, Widget? child) => Container(
        padding: const EdgeInsets.all(MARGIN_LARGE),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
            border: Border.all(color: Colors.black, width: 1)),
        child: Stack(
          children: [
            Container(
              child: bloc.chooseImageFile != null
                  ? SizedBox(
                      height: 300,
                      child: Image.file(
                        bloc.chooseImageFile ?? File(""),
                        fit: BoxFit.contain,
                      ),
                    )
                  : GestureDetector(
                      child: SizedBox(
                        height: 300,
                        child: Image.network(
                          "https://w7.pngwing.com/pngs/637/822/png-transparent-font-awesome-upload-computer-icons-font-computers-blue-text-logo.png",
                        ),
                      ),
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          bloc.onImageChosen(
                            File(image.path),
                          );
                        }
                      },
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: bloc.chooseImageFile != null ? true : false,
                child: InkWell(
                  onTap: () {
                    bloc.onTapDeleteImage();
                  },
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostErrorWidget extends StatelessWidget {
  const PostErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
        builder: (BuildContext context, bloc, Widget? child) => Visibility(
            visible: bloc.isAddNewPostError,
            child: const Text(
              "Post Shouldn't be empty",
              style: TextStyle(color: Colors.red),
            )));
  }
}

class PostButtonView extends StatelessWidget {
  const PostButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, bloc, Widget? child) => PrimaryButtonView(
        themeColor: bloc.themeColor,
        label: LBL_POST,
        onTap: () {
          bloc.onTapAddNewPost().then((value) {
            Navigator.pop(context);
          });
        },
      ),
    );
  }
}

class AddNewPostTextFieldView extends StatelessWidget {
  const AddNewPostTextFieldView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, bloc, Widget? child) => SizedBox(
        height: ADD_NEW_POST_TEXTFIELD_HEIGHT,
        child: TextField(
          maxLines: 24,
          controller: TextEditingController(text: bloc.description),
          onChanged: (text) {
            bloc.onNewPostTextChanged(text);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                MARGIN_MEDIUM,
              ),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            hintText: "What's on your mind?",
          ),
        ),
      ),
    );
  }
}
