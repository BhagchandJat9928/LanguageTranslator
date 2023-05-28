import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText extends StatelessWidget {
  const CustomText(this.data,
      {Key? key, this.fontSize, this.color, this.maxLines})
      : super(key: key);
  final double? fontSize;
  final Color? color;
  final String data;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      data.tr,
      softWrap: true,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
