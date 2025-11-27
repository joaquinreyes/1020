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
import 'package:hop/globals/images.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/models/approve_request_socket_response.dart';
import 'package:hop/models/service_detail_model.dart';
import 'package:hop/repository/booking_repo.dart';
import 'package:hop/repository/payment_repo.dart';
import 'package:hop/screens/payment_information/payment_information.dart';
import 'package:hop/utils/custom_extensions.dart';

class EventApprovedRequestDialog extends ConsumerStatefulWidget {
  const EventApprovedRequestDialog({
    super.key,
    required this.data,
  });

  final ApprovedRequest_SocketResponse data;

  @override
  ConsumerState<EventApprovedRequestDialog> createState() =>
      _ApprovedRequestDialogState();
}

class _ApprovedRequestDialogState
    extends ConsumerState<EventApprovedRequestDialog> {
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
            "YOU_HAVE_BEEN_ACCEPTED_INTO_THE_TEAM".trU(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupHeaderTextStyle
                .copyWith(color: AppColors.white),
          ),
          SizedBox(height: 20.h),
          ApplicantOpenMatchInfoCard(
            service: widget.data.serviceBooking!,
          ),
          SizedBox(height: 20.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "CURRENT_TEAM".tr(context),
              style: AppTextStyles.manropeLight(fontSize: 16.sp,color: AppColors.white,),
            ),
          ),
          SizedBox(height: 5.h),
          OpenMatchParticipantRowWithBG(
            textForAvailableSlot: "AVAILABLE".trU(context),
            players: widget.data.serviceBooking?.players ?? [],
            showReserveReleaseButton: false,
            maxPlayers: 2,
            backgroundColor: AppColors.white25,
            imageBgColor: AppColors.white,
            imageLogoColor: AppColors.black2,
            slotBackgroundColor: AppColors.black2,
            textColor: AppColors.white,
          ),
          SizedBox(height: 20.h),
          _secondaryButtons(false, context, widget.data.serviceBooking!),
          SizedBox(height: 15.h),
          MainButton(
            label: "PAY_MY_SHARE".tr(context),
            onTap: _payCourt,
          ),
        ],
      ),
    );
  }

  _payCourt() async {
    final locationID = widget.data.serviceBooking!.service!.location!.id;
    final price = widget.data.serviceBooking!.service!.price;
    final service = widget.data.serviceBooking;

    final serviceID = widget.data.waitingList?.serviceBookingId;
    if (locationID == null ||
        price == null ||
        serviceID == null ||
        service == null) {
      return;
    }


    final canProceed = await Utils().checkForLevelAssessment(
        ref: ref, context: context, sportsName: service.getSportsName(ref));

    if (!canProceed) {
      return;
    }

    final provider = fetchCourtPriceProvider(
        courtId: [service.courtId],
        coachId: null,
        serviceId: service.id ?? 0,
        durationInMin: service.duration2,
        requestType: CourtPriceRequestType.join,
        dateTime: DateTime.now());
    await Utils.showLoadingDialog(context, provider, ref);

    final data = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            type: PaymentDetailsRequestType.join,
            locationID: locationID,
            requestType: PaymentProcessRequestType.join,
            price: price,
            courtId: service.courtId,
            serviceID: serviceID,
            isJoiningApproval: true,
            duration: service.duration2,
            startDate: service.bookingStartTime);
      },
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

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 13.w,
      imageWidth: 13.w,
      onTap: () {
        if (widget.data.serviceBooking != null) {
          Utils.shareEventLessonUrl(
              context: context,
              service: widget.data.serviceBooking!,
              isLesson: false);
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
      onTap: () {
        String title =
            "Event @ ${widget.data.serviceBooking?.service?.location?.locationName ?? ""}";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.data.serviceBooking!.bookingStartTime,
          endDate: widget.data.serviceBooking!.bookingEndTime,
        ));
      },
    );
  }

  Row _secondaryButtons(
      bool isJoined, BuildContext context, ServiceDetail service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!service.isPast) _addToCalendarButton(context),
          ],
        ),
        const Spacer(),
        _shareMatchButton(context),
      ],
    );
  }
}
