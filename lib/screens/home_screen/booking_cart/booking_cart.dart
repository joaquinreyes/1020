import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/utils/custom_extensions.dart';
import '../../../app_styles/app_colors.dart';
import '../../../app_styles/app_text_styles.dart';
import '../../../models/multi_booking_model.dart';
import '../../../repository/booking_repo.dart';
import 'booking_cart_dialog/booking_cart_dialog.dart';

class BookingCart extends ConsumerStatefulWidget {
  const BookingCart({super.key});

  @override
  ConsumerState<BookingCart> createState() => BookingCartState();
}

class BookingCartState extends ConsumerState<BookingCart> {
  @override
  Widget build(BuildContext context) {
    List<MultipleBookings> bookingCartList = [];
    ref
        .watch(fetchBookingCartListProvider)
        .whenData((e) => bookingCartList = e);
    if (bookingCartList.isEmpty) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        _onTap(bookingCartList);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r),),
          color: AppColors.blue,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "BOOKING_CART".trU(context),
              style: AppTextStyles.sofiaSansMedium(
                fontSize: 20.sp,
                color: AppColors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 18.w,
              height: 18.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.white, shape: BoxShape.circle),
              padding: EdgeInsets.all(2.w),
              child: Text(bookingCartList.length.toString(),
                  style:
                      AppTextStyles.sofiaSansMedium(color: AppColors.blue,fontSize: 17.sp,height: 1),),
            ),
            SizedBox(width: 35.w),
            const Icon(Icons.keyboard_arrow_up, color: AppColors.white,),
          ],
        ),
      ),
    );
  }

  _onTap(List<MultipleBookings> list) {
    showDialog(
      context: context,
      builder: (context) {
        return const BookingCartDialog();
      },
    );
  }
}
