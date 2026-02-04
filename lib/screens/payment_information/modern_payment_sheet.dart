import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/app_styles/app_text_styles.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/utils/custom_extensions.dart';

/// Shows a payment sheet as a modal bottom sheet
Future<T?> showPaymentSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => child,
  );
}

/// Colors matching the app's warm cream/brown theme
class PaymentSheetColors {
  // Background colors
  static const Color dialogBackground = Color(0xFFFAFAF5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF5F5F0);

  // Text colors
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF666666);
  static const Color tertiaryText = Color(0xFF999999);

  // Accent colors
  static const Color accent = Color(0xFF994433);
  static const Color accentLight = Color(0xFFFDF8F6);
  static const Color success = Color(0xFF4CAF50);
  static const Color destructive = Color(0xFFD32F2F);

  // Border colors
  static const Color border = Color(0xFFE5E5E0);
  static const Color divider = Color(0xFFEEEEE8);

  // Button
  static const Color buttonYellow = Color(0xFFFFDD77);
}

/// Bottom sheet drawer for payment
class ModernPaymentSheet extends StatelessWidget {
  const ModernPaymentSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onClose,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: PaymentSheetColors.dialogBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: PaymentSheetColors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: AppTextStyles.manropeBold(
                            fontSize: 20.sp,
                            color: PaymentSheetColors.primaryText,
                          ),
                        ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          style: AppTextStyles.manropeMedium(
                            fontSize: 13.sp,
                            color: PaymentSheetColors.secondaryText,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: PaymentSheetColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: child,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
        ],
      ),
    );
  }
}

/// Coupon input section
class ModernCouponSection extends StatelessWidget {
  const ModernCouponSection({
    super.key,
    required this.controller,
    required this.onApply,
    required this.isApplied,
    required this.isInvalid,
    this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onApply;
  final bool isApplied;
  final bool isInvalid;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: PaymentSheetColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: PaymentSheetColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'COUPON'.tr(context).toUpperCase(),
                style: AppTextStyles.manropeSemiBold(
                  fontSize: 11.sp,
                  color: PaymentSheetColors.secondaryText,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${'OPTIONAL'.tr(context).toLowerCase()})',
                style: AppTextStyles.manropeMedium(
                  fontSize: 11.sp,
                  color: PaymentSheetColors.tertiaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: PaymentSheetColors.inputBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: AppTextStyles.manropeMedium(
                      fontSize: 15.sp,
                      color: PaymentSheetColors.primaryText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ENTER_COUPON_HERE'.tr(context),
                      hintStyle: AppTextStyles.manropeMedium(
                        fontSize: 15.sp,
                        color: PaymentSheetColors.tertiaryText,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _buildSuffixIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuffixIcon() {
    if (isApplied) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Icon(
          Icons.check_circle,
          color: PaymentSheetColors.success,
          size: 22.sp,
        ),
      );
    }
    if (isInvalid) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Icon(
          Icons.error,
          color: PaymentSheetColors.destructive,
          size: 22.sp,
        ),
      );
    }
    return GestureDetector(
      onTap: onApply,
      child: Container(
        margin: EdgeInsets.only(right: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: PaymentSheetColors.accent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }
}

/// Amount display box with brown gradient
class ModernAmountDisplay extends StatelessWidget {
  const ModernAmountDisplay({
    super.key,
    required this.amount,
    this.originalAmount,
    this.label,
  });

  final double amount;
  final double? originalAmount;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalAmount != null && originalAmount! > amount;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            PaymentSheetColors.accent,
            PaymentSheetColors.accent.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? 'AMOUNT_PAYABLE'.tr(context),
            style: AppTextStyles.manropeMedium(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Row(
            children: [
              if (hasDiscount) ...[
                Text(
                  Utils.formatPrice(originalAmount!),
                  style: AppTextStyles.manropeMedium(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.6),
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                Utils.formatPrice(amount),
                style: AppTextStyles.manropeBold(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Payment method card with radio or toggle
class ModernPaymentMethodCard extends StatelessWidget {
  const ModernPaymentMethodCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.iconPath,
    this.showToggle = false,
    this.isToggled = false,
    this.onToggle,
    this.prefix,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final String? iconPath;
  final bool showToggle;
  final bool isToggled;
  final ValueChanged<bool>? onToggle;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showToggle ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? PaymentSheetColors.accentLight : PaymentSheetColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? PaymentSheetColors.accent : PaymentSheetColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? PaymentSheetColors.accent.withOpacity(0.1)
                    : PaymentSheetColors.inputBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath!,
                        width: 22.w,
                        height: 22.w,
                        color: isSelected ? PaymentSheetColors.accent : PaymentSheetColors.secondaryText,
                      )
                    : Icon(
                        icon ?? Icons.account_balance_wallet_outlined,
                        size: 22.sp,
                        color: isSelected ? PaymentSheetColors.accent : PaymentSheetColors.secondaryText,
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.manropeSemiBold(
                      fontSize: 15.sp,
                      color: isSelected ? PaymentSheetColors.accent : PaymentSheetColors.primaryText,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.manropeMedium(
                        fontSize: 12.sp,
                        color: PaymentSheetColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Toggle or radio indicator
            if (showToggle)
              CupertinoSwitch(
                value: isToggled,
                activeColor: PaymentSheetColors.accent,
                trackColor: PaymentSheetColors.border,
                onChanged: (value) {
                  onToggle?.call(value);
                  onTap();
                },
              )
            else if (prefix != null)
              prefix!
            else
              // Radio indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? PaymentSheetColors.accent : PaymentSheetColors.border,
                    width: isSelected ? 6 : 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Section header
class ModernSectionHeader extends StatelessWidget {
  const ModernSectionHeader({
    super.key,
    required this.title,
    this.padding,
  });

  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(top: 16.h, bottom: 10.h),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.manropeSemiBold(
          fontSize: 11.sp,
          color: PaymentSheetColors.secondaryText,
        ),
      ),
    );
  }
}

/// Primary button with yellow background
class ModernPrimaryButton extends StatelessWidget {
  const ModernPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !isLoading ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(top: 16.h),
        height: 56.h,
        decoration: BoxDecoration(
          color: enabled ? PaymentSheetColors.buttonYellow : PaymentSheetColors.divider,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: enabled ? const Color(0xFFD4A853) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(PaymentSheetColors.primaryText),
                  ),
                )
              : Text(
                  label.toUpperCase(),
                  style: AppTextStyles.manropeSemiBold(
                    fontSize: 16.sp,
                    color: enabled ? PaymentSheetColors.accent : PaymentSheetColors.tertiaryText,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Payment methods list container
class ModernPaymentMethodsList extends StatelessWidget {
  const ModernPaymentMethodsList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
