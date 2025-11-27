import 'package:flutter/material.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/globals/images.dart';

class BackgroundView extends StatelessWidget {
  final Widget child;

  const BackgroundView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.white,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(AppImages.backgroundImage.path),
      //     fit: BoxFit.cover,
      //     alignment: Alignment.topCenter,
      //   ),
      // ),
      child: child,
    );
  }
}