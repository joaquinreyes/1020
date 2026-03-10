import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/managers/api_manager.dart' show kBaseURL, kClubID;
import 'package:hop/utils/custom_extensions.dart';

import '../app_styles/app_colors.dart';
import '../app_styles/app_text_styles.dart';
import '../routes/app_pages.dart';
import 'custom_dialog.dart';
import 'main_button.dart';

class TermsAndCondition extends ConsumerStatefulWidget {
  final bool showButton;
  final bool isTerms;
  final ScrollController scrollController;

  const TermsAndCondition(
      {super.key,
      this.isTerms = true,
      this.showButton = false,
      required this.scrollController});

  @override
  ConsumerState<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends ConsumerState<TermsAndCondition> {
  String? _backendText;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPolicies();
  }

  Future<void> _fetchPolicies() async {
    try {
      final response = await Dio().get('$kBaseURL/$kClubID/policies');
      final data = response.data?['data'];
      if (data != null) {
        final text = widget.isTerms
            ? data['terms_and_conditions']
            : data['privacy_policy'];
        if (text != null && text.toString().isNotEmpty) {
          // Strip HTML tags for plain text display
          final stripped = text
              .toString()
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .replaceAll('&nbsp;', ' ')
              .replaceAll('&amp;', '&')
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>')
              .replaceAll('&quot;', '"')
              .trim();
          if (stripped.isNotEmpty) {
            setState(() {
              _backendText = stripped;
            });
          }
        }
      }
    } catch (_) {
      // Fallback to locale text
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackText = widget.isTerms
        ? "TERMS_AND_CONDITIONS_TEXT".tr(context)
        : "COMMUNICATIONS_TEXT".tr(context);

    final displayText = _backendText ?? fallbackText;

    return CustomDialog(
        color: AppColors.white,
        closeIconColor: AppColors.blue,
        contentPadding: EdgeInsets.only(top: 15.w, right: 15.w, left: 15.w,bottom: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              widget.isTerms
                  ? "TERMS_AND_CONDITIONS".trU(context)
                  : "COMMUNICATIONS".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.blue),
            ),
            ),
            SizedBox(
              height: 20.h,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    displayText,
                    style: AppTextStyles.manropeMedium(
                        fontSize: 15.sp, color: AppColors.blue,),
                    textAlign: TextAlign.center,
                  ),

            if (widget.showButton)
              Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 15, right: 15),
                  child: MainButton(
                    label: "AGREE_AND_CONTINUE".trU(context),
                    isForPopup: true,
                    onTap: () {
                      ref.read(goRouterProvider).pop(true);
                    },
                    borderRadius: 12.r,
                    height: 40.h,
                    width: double.infinity,
                  )),
            SizedBox(
              height: 20.h,
            ),
          ],
        ));
  }
}
