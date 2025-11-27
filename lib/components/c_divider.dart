import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';

class CDivider extends StatelessWidget {
  CDivider({super.key, Color? color}) : color = color ?? AppColors.black5;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1.h, color: color);
  }
}
