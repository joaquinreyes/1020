import 'dart:math';

import 'package:hop/components/custom_dialog.dart';
import 'package:hop/components/custom_textfield.dart';
import 'package:hop/components/multi_style_text.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/CustomDatePicker/flutter_datetime_picker.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dropdown.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/app_user.dart';
import 'package:hop/models/custom_fields.dart';
import 'package:hop/repository/user_repo.dart';
import 'package:hop/routes/app_pages.dart';
import 'package:hop/routes/app_routes.dart';
import 'package:hop/screens/home_screen/home_screen.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/utils/dubai_date_time.dart';
import '../../../../../components/secondary_text.dart';
import '../../../../../globals/constants.dart';
import '../../../../../models/transaction_model.dart';
import '../../../../auth/signin/signin_screen.dart';
import '../../../../../components/language_selector_auth.dart';

part 'settings_edit_profile.dart';
part 'providers.dart';

part 'settings_components.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpComingBookingsState();
}

class _UpComingBookingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(userProvider);
    final user = appUser?.user;
    final userLevelPadel = user?.level(kSportName);
    final userLevelPickleBall = user?.level(kPickleBallName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERSONAL_INFORMATION'.trU(context),
              style: AppTextStyles.sofiaSansMedium(
                  fontSize: 23.sp,),
            ),
            SecondaryImageButton(
              label: "EDIT".tr(context),
              image: AppImages.editIcon.path,
              imageHeight: 13.h,
              imageWidth: 13.h,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => _EditProfile(
                    user: user!,
                  ),
                );
              },
            )
          ],
        ),
        SizedBox(height: 12.h),
        _buildInfoField("FIRST_NAME".tr(context), user?.firstName ?? ""),
        SizedBox(height: 8.h),
        _buildInfoField("SURNAME".tr(context), user?.lastName ?? ""),
        SizedBox(height: 8.h),
        _buildInfoField("EMAIL".tr(context), user?.email ?? ""),
        SizedBox(height: 8.h),
        _buildInfoField("PHONE_NUMBER".tr(context), user?.phoneNumber ?? ""),
        SizedBox(height: 8.h),
        _buildInfoField("PADEL_LEVEL".tr(context), (userLevelPadel ?? 0).formatString()),
        SizedBox(height: 8.h),
        _buildInfoField("PICKLEBALL_LEVEL".tr(context), (userLevelPickleBall ?? 0).formatString()),
        if (user != null)
          _CustomFields(
            user: user,
          ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LANGUAGE'.tr(context),
              style: AppTextStyles.manropeSemiBold(
                fontSize: 16.sp,
              ),
            ),
            const LanguageSelectorAuth(),
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(height: 42.h),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'PAYMENT_SETTINGS'.trU(context),
        //           style: AppTextStyles.sofiaSansMedium(
        //               fontSize: 23.sp,),
        //         ),
        //         SecondaryImageButton(
        //           label: "EDIT".tr(context),
        //           image: AppImages.editIcon.path,
        //           imageHeight: 11.h,
        //           imageWidth: 11.w,
        //           onTap: () {
        //             // showDialog(
        //             //   context: context,
        //             //   builder: (context) => _EditProfile(
        //             //     user: user!,
        //             //   ),
        //             // );
        //           },
        //         )
        //       ],
        //     ),
        //     SizedBox(height: 12.h),
        //     paymentDetails.when(
        //         data: (data) {
        //           if (data.isNotEmpty) {
        //             return _buildInfoField("BALANCE".tr(context),
        //                 Utils.formatPrice2(data.first.balance, currency));
        //           }
        //
        //           return _buildInfoField(
        //               "BALANCE".tr(context), Utils.formatPrice2(0, currency));
        //         },
        //         error: (error, stackTrace) => _buildInfoField(
        //             "BALANCE".tr(context), Utils.formatPrice2(0, currency)),
        //         loading: () => const Center(
        //               child: CupertinoActivityIndicator(
        //                 radius: 10,
        //               ),
        //             ))
        //   ],
        // ),
        SizedBox(height: 40.h),
        const TransactionList(),
        SizedBox(height: 40.h),
        const _DeletePasswordBtns(),
        SizedBox(height: 30.h),
      ],
    );
  }
}
