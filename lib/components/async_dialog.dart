import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_colors.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/components/custom_dialog.dart';
import 'package:hop/globals/images.dart';
import 'package:hop/utils/custom_extensions.dart';

class AsyncDialog<T> extends ConsumerWidget {
  const AsyncDialog(
      {Key? key, required this.provider, this.isUpperCase = false})
      : super(key: key);
  final AutoDisposeFutureProvider<T> provider;
  final bool isUpperCase;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    ref.listen(provider, (pre, next) {
      if (pre == next) {
        return;
      }
      if (next.hasError) {
        return;
      }
      if (next.value is T) {
        Navigator.pop(context, next.value);
      }
    });
    return CustomDialog(
        color: AppColors.brick,
        // color: (async.hasError) ? AppColors.black : AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 6.5.w, vertical: 10.h),
        showCloseIcon: async.hasError,
        // color: AppColors.black2,
        child: async.when(
          data: (data) {
            return _loading(context);
          },
          error: (error, stackTrace) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString().trU(context),
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
                SizedBox(height: 25.h),
              ],
            );
          },
          loading: () {
            return _loading(context);
          },
        ));
  }

  Widget _loading(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Image.asset(
                AppImages.loadingGif.path,
                height: 50.h,
                width: 50.h,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'loading'.trU(context),
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
              ),
            ],
          )),
    );
  }
}
