import 'package:flutter/material.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/resources/dimensions.dart';
import 'package:social_media_app/resources/images.dart';

class PostItemView extends StatelessWidget {
  const PostItemView({Key? key, required this.newsFeed, required this.onTapDelete, required this.onTapEdit}) : super(key: key);
  final NewsFeedVO? newsFeed;
  final Function(int,String) onTapDelete;
  final Function(int, String) onTapEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ProfileImageView(profileImage: newsFeed?.profilePicture,),
            const SizedBox(
              width: MARGIN_MEDIUM_2,
            ),
            NameLocationAndTimeAgoView(userName: newsFeed?.userName,),
            const Spacer(),
            MoreButtonView(onTapDelete: () {
              onTapDelete(newsFeed?.id ?? 0, newsFeed?.userName ?? "");
            }, onTapEdit: () {onTapEdit(newsFeed?.id ?? 0, newsFeed?.userName ?? "");},)
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PostImageView(postImage: newsFeed?.postImage,),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PostDescriptionView(
          description: newsFeed?.description,
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Row(
          children: const [
            Text(
              "See Comments",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Icon(
              Icons.mode_comment_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: MARGIN_MEDIUM,
            ),
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
            )
          ],
        )
      ],
    );
  }
}

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    this.profileImage,
    super.key,
  });

  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MARGIN_LARGE),
      child:FadeInImage(
        height: 50,
        width: 50,
        placeholder:const NetworkImage(
          NETWORK_IMAGE_POST_PLACEHOLDER,
        ),
        image: NetworkImage(
          profileImage ?? "https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg"
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

class NameLocationAndTimeAgoView extends StatelessWidget {
  final String? userName;

  const NameLocationAndTimeAgoView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userName ?? "",
              style: const TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: MARGIN_SMALL,
            ),
            const Text(
              "- 2 hours ago",
              style: TextStyle(
                fontSize: TEXT_SMALL,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        const Text(
          "Paris",
          style: TextStyle(
            fontSize: TEXT_SMALL,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class MoreButtonView extends StatelessWidget {
  final Function onTapDelete;
  final Function onTapEdit;
  const MoreButtonView({
    Key? key,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onTapEdit();
          },
          value: 1,
          child: const Text("Edit"),
        ),
        PopupMenuItem(
          onTap: () {
            onTapDelete();
          },
          value: 2,
          child: const Text("Delete"),
        )
      ],
    );
  }
}

class PostImageView extends StatelessWidget {
  final String? postImage;

  const PostImageView({
    Key? key,
    required this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: postImage!=null && postImage!="" ? true : false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
        child: FadeInImage(
          height: 200,
          width: double.infinity,
          placeholder: const NetworkImage(
            NETWORK_IMAGE_POST_PLACEHOLDER,
          ),
          image: NetworkImage(
            postImage ?? "",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PostDescriptionView extends StatelessWidget {
  final String? description;

  const PostDescriptionView({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? "",
      style: const TextStyle(
        fontSize: TEXT_REGULAR,
        color: Colors.black,
      ),
    );
  }
}