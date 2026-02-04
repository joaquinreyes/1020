import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/active_memberships.dart';
import 'package:hop/utils/custom_extensions.dart';
import 'package:hop/box_shadow/flutter_inset_box_shadow.dart' as inset;
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../components/c_divider.dart';
import '../../../../../../components/main_button.dart';
import '../../../../../../components/secondary_text.dart';
import '../../../../../../globals/constants.dart';
import '../../../../../../globals/images.dart';
import '../../../../../../models/membership_list_category_model.dart';
import '../../../../../../models/membership_model.dart';
import '../../../../../../models/user_membership.dart';
import '../../../../../../repository/booking_repo.dart';
import '../../../../../../repository/payment_repo.dart';
import '../../../../../payment_information/payment_information.dart';
import '../../../../../payment_information/modern_payment_sheet.dart';

part 'membership_tab_component.dart';

part 'membership_tab_provider.dart';

class MembershipTab extends ConsumerWidget {
  const MembershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEMBERSHIP_INFORMATION'.trU(context),
          style: AppTextStyles.sofiaSansMedium(
              fontSize: 23.sp,),
        ),
        SizedBox(height: 10.h),
        membership.when(
            data: (data) {
              if (data.membershipModel.isEmpty) {
                return SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context));
              }
              final selectedMembershipCategory =
                  ref.watch(selectedMembershipCatIndex);

              if (data.showMembershipCategories.isNotEmpty &&
                  selectedMembershipCategory.isEmpty) {
                final wellnessCategory = data.showMembershipCategories
                    .firstWhere(
                        (element) =>
                            (element.categoryName ?? "")
                                .toString()
                                .trim()
                                .toLowerCase() ==
                            "wellness",
                        orElse: () => data.showMembershipCategories.first);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(selectedMembershipCatIndex.notifier).state =
                      wellnessCategory.id;
                });
              }

              return Column(
                children: [
                  if (allowShowPadelMembershipInProfile)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _MembershipCategorySelection(
                          showMembershipCategories:
                              data.showMembershipCategories),
                    ),
                  MembershipListComponent(data: data,showAllMembership: false),
                ],
              );
            },
            error: (e, _) =>
                SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context)),
            loading: () => const Center(child: CupertinoActivityIndicator()))
      ],
    );
  }
}
