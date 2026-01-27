import 'package:flutter/material.dart';
import 'package:github_explorer_1o1/core/static/colors.dart';

class CodeIcon extends StatelessWidget {
  const CodeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: kCardColor,
        shape: BoxShape.circle,
        border: Border.all(color: kGreenNeon),
      ),
      child: Icon(Icons.code_rounded, color: kGreenNeon, size: 40),
    );
  }
}
