import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:social_media_app/resources/dimensions.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: MARGIN_XXLARGE,
          height: MARGIN_XXLARGE,
          child: LoadingIndicator(
            indicatorType: Indicator.audioEqualizer,
            colors: [Colors.white],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}