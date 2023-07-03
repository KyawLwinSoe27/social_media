import 'package:flutter/material.dart';
import 'package:social_media_app/resources/dimensions.dart';

class PrimaryButtonView extends StatelessWidget {
  final String label;
  final Color themeColor;
  final Function() onTap;

  const PrimaryButtonView({
    Key? key,
    required this.label,
    this.themeColor = Colors.black,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        height: MARGIN_XXLARGE,
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(
            MARGIN_LARGE,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
