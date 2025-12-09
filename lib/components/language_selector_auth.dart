import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:hop/globals/constants.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../managers/shared_pref_manager.dart';
import '../screens/app_provider.dart';


class LanguageSelectorAuth extends ConsumerStatefulWidget {
  const LanguageSelectorAuth({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LanguageSelectorAuthState();
}

class _LanguageSelectorAuthState extends ConsumerState<LanguageSelectorAuth> {
  String? selectedLocale;
  @override
  Widget build(BuildContext context) {
    String currentLocale = ref.watch(languageValueProvider).languageCode;
    selectedLocale = currentLocale;
    return Container(
      decoration: inset.BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: AppColors.black5,
        boxShadow: kInsetShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      child: Row(
        children: [
          _buildWidget("RUSSIAN".tr(context).toLowerCase().capitalizeFirst, "ru", currentLocale),
          _buildWidget("ENGLISH".tr(context).toLowerCase().capitalizeFirst, "en", currentLocale),
        ],
      ),
    );
  }

  _buildWidget(String text, String locale, String currentLocale) {
    final isSelected = locale == currentLocale;
    return InkWell(
      borderRadius: BorderRadius.circular(100.r),
      onTap: () {
        _switchLocale(locale);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
        child: Text(
          text,
          style: isSelected ? AppTextStyles.manropeSemiBold(fontSize: 13.sp,color: AppColors.white) : AppTextStyles.manropeMedium(fontSize: 13.sp).copyWith(color: AppColors.black70,),
        ),
      ),
    );
  }

  _switchLocale(String locale) async {
    if (selectedLocale == locale) return;
    await ref.read(sharedPrefManagerProvider).setLanguage(locale);
    if(!mounted){
      return;
    }
    log("Henil Zadafya $selectedLocale : $locale");
    ref
        .read(languageValueProvider.notifier)
        .setLanguage = locale;


    // ref.read(currentLocaleProvider.notifier).state = locale;

    // setState(() {
    //   selectedLocale = locale;
    // });
  }
}
