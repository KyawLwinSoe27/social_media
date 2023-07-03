import 'package:flutter/material.dart';

import '../resources/dimensions.dart';

class PageTitleWidgetView extends StatelessWidget {
  final String titleText;
  const PageTitleWidgetView({
    super.key,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: MARGIN_LARGE,horizontal: MARGIN_LARGE),
      child: Text(
        titleText,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}