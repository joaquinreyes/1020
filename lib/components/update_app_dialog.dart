import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
      showCloseIcon: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PLEASE_UPDATE_THE_APP".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          Text(
            "UPDATE_DESC".tr(context),
            style: AppTextStyles.popupBodyTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          MainButton(
            isForPopup: true,
            label: "UPDATE_NOW".trU(context),
            onTap: () {
              launchUrl(Uri.parse(url));
            },
          )
        ],
      ),
    );
  }
}
