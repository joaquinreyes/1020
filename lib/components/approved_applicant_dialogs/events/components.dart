part of 'events_applicant_dialog.dart';

class ApplicantEventInfoCard extends StatelessWidget {
  const ApplicantEventInfoCard({super.key, required this.service});
  final ServiceDetail service;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.lightOrange35Popup,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                service.service?.event?.eventName ?? "",
                style: AppTextStyles.manropeMedium(),
              ),
              const Spacer(),
              Text(
                "DATE_AND_TIME".tr(context),
                style: AppTextStyles.manropeMedium(),
              )
            ],
          ),
          SizedBox(height: 1.h),
          CDivider(),
          SizedBox(height: 2.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (service.service?.location?.locationName ?? "")
                        .capitalizeFirst,
                    style: AppTextStyles.manropeMedium(),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${"PRICE".tr(context)} ${Utils.formatPrice(service.service?.price?.toDouble())}",
                    style: AppTextStyles.manropeMedium(),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    service.formatBookingDate,
                    style: AppTextStyles.manropeMedium(),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    service.formatStartEndTime,
                    style: AppTextStyles.manropeMedium(),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
