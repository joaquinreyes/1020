import 'package:hop/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';

import 'package:hop/components/approved_applicant_dialogs/open_match/open_match_applicants_dialog.dart';
import 'package:hop/components/main_button.dart';
import 'package:hop/components/open_match_participant_row.dart';
import 'package:hop/components/secondary_button.dart';
import 'package:hop/globals/constants.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/models/approve_request_socket_response.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/repository/play_repo.dart';
import 'package:hop/screens/open_match_detail/open_match_detail.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/screens/payment_information/modern_payment_sheet.dart';
import 'package:hop/utils/custom_extensions.dart';

class OpenMatchApprovedRequestDialog extends ConsumerStatefulWidget {
  const OpenMatchApprovedRequestDialog({
    super.key,
    required this.data,
  });
  final ApprovedRequest_SocketResponse data;

  @override
  ConsumerState<OpenMatchApprovedRequestDialog> createState() =>
      _ApprovedRequestDialogState();
}

class _ApprovedRequestDialogState
    extends ConsumerState<OpenMatchApprovedRequestDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "YOU_HAVE_BEEN_ACCEPTED_INTO_THE_MATCH".trU(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.manropeBold(fontSize: 19.sp)
                    .copyWith(letterSpacing: 19.sp * 0.12),
          ),
          SizedBox(height: 20.h),
          ApplicantOpenMatchInfoCard(
            service: widget.data.serviceBooking!,
          ),
          SizedBox(height: 20.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "CURRENT_PLAYERS".tr(context),
              style: AppTextStyles.manropeLight().copyWith(
                fontSize: 15.sp,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          OpenMatchParticipantRowWithBG(
            borderRadius: BorderRadius.circular(12.r),
            textForAvailableSlot: "AVAILABLE".tr(context),
            players: widget.data.serviceBooking?.players ?? [],
            showReserveReleaseButton: false,
            backgroundColor: AppColors.black25,
            textColor: AppColors.black2,
            imageBgColor: AppColors.white,
            imageLogoColor: AppColors.blue2,
          ),
          SizedBox(height: 20.h),
          _secondaryButtons(false, context, widget.data.serviceBooking!),
          SizedBox(height: 15.h),
          MainButton(
            isForPopup: true,
            label: "PAY_MY_SHARE".tr(context),
            onTap: _payCourt,
          ),
        ],
      ),
    );
  }

  _payCourt() async {
    final locationID = widget.data.serviceBooking!.service!.location!.id;
    final service = widget.data.serviceBooking;

    final price = widget.data.serviceBooking!.service!.price;
    final serviceID = widget.data.waitingList?.serviceBookingId;
    if (locationID == null ||
        price == null ||
        serviceID == null ||
        service == null) {
      return;
    }
    final canProceed = await Utils().checkForLevelAssessment(
      ref: ref,
      context: context,
      sportsName: service.getSportsName(ref),
      isOpenMatchFlow: true,
    );

    if (!canProceed) {
      return;
    }

    final data = await showDialog(
      context: context,
      builder: (context) {
        return OpenMatchChooseSpotDialog(
          players: widget.data.serviceBooking!.players ?? [],
        );
      },
    );
    if (!mounted || data == null) {
      return;
    }
    final (int index, _) = data;
    ConfirmationDialogType dialogType = ConfirmationDialogType.join;
    final bool? join = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        type: dialogType,
      ),
    );
    final playerID = ref.read(userManagerProvider).user?.user?.id;
    if (join == true && context.mounted && mounted && playerID != null) {
      final provider = joinServiceProvider(serviceID,
          position: index + 1,
          isEvent: false,
          isOpenMatch: true,
          isDouble: false,
          isReserve: false,
          isLesson: false,
          isApprovalNeeded: true);
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);

      if (!mounted || price == null) {
        return;
      }
      final courtPrice = fetchCourtPriceProvider(
          serviceId: service.id ?? 0,
          courtId: [service.courtId],
          durationInMin: service.duration2,
          coachId: null,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final data = await showPaymentSheet(
        context: context,
        child: PaymentInformation(
            type: PaymentDetailsRequestType.join,
            locationID: locationID,
            courtId: service.courtId,

            requestType: PaymentProcessRequestType.join,
            price: price,
            serviceID: serviceID,
            isJoiningApproval: true,
            duration: service.duration2,
            startDate: service.bookingStartTime),
      );
      var (int? postPaymentServiceID, double? amount) = (null, null);
      if (data is (int, double?)) {
        (postPaymentServiceID, amount) = data;
      }

      if (postPaymentServiceID != null && mounted) {
        Navigator.pop(context);
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_JOINED_THE_MATCH".tr(context),
        );
      }
    }
  }

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 13.w,
      imageWidth: 13.w,
      isForPopup: true,
      onTap: () {
        if (widget.data.serviceBooking != null) {
          Utils.shareOpenMatch(context, widget.data.serviceBooking!, ref);
        }
      },
    );
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      isForPopup: true,
      onTap: () {
        String title = "$kSportName Match";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.data.serviceBooking!.bookingStartTime,
          endDate: widget.data.serviceBooking!.bookingEndTime,
        ));
      },
    );
  }

  Widget _secondaryButtons(
      bool isJoined, BuildContext context, ServiceDetail service) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!service.isPast) _addToCalendarButton(context),
          SizedBox(height: 10.h),
          _shareMatchButton(context),
      
        ],
      ),
    );
  }
}
