import 'package:flutter/material.dart';
import 'package:social_media_app/resources/dimensions.dart';

class LabelAndTextFieldView extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Function(String) onChanged;

  const LabelAndTextFieldView({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            labelText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: MARGIN_SMALL),
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              onChanged: (val) => onChanged(val),
            ),
          )
        ],
      ),
    );
  }
}