import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Function() onTap;
  const TextRow({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          firstText,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(
          width: 10.0,
        ),
        InkWell(
          onTap: () => onTap(),
          child: Text(secondText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
        )
      ],
    );
  }
}