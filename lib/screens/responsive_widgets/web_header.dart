import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import '../../globals/images.dart';
import '../home_screen/tabs/profile_tab/profile_tab.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: Image.asset(
                AppImages.webHeader.path,
                width: 440.w,
                height: 70.h,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),

            const Spacer(),
            SignOutButtonComponent()
          ],
        ),
      ),
    );
  }
}
