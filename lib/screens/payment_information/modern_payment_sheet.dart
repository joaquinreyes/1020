import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hop/globals/utils.dart';
import 'package:hop/utils/custom_extensions.dart';

/// Modern iOS-style colors for the payment sheet
class PaymentSheetColors {
  // Background colors
  static const Color sheetBackground = Color(0xFFF2F2F7);
  static const Color cardBackground = Colors.white;
  static const Color overlayBackground = Color(0x99000000);

  // Text colors
  static const Color primaryText = Color(0xFF1C1C1E);
  static const Color secondaryText = Color(0xFF8E8E93);
  static const Color tertiaryText = Color(0xFFAEAEB2);

  // Accent colors
  static const Color accent = Color(0xFF994433);
  static const Color accentLight = Color(0xFFFFF5F2);
  static const Color success = Color(0xFF34C759);
  static const Color destructive = Color(0xFFFF3B30);

  // Divider and borders
  static const Color divider = Color(0xFFE5E5EA);
  static const Color border = Color(0xFFD1D1D6);

  // Switch colors
  static const Color switchActive = Color(0xFF994433);
  static const Color switchInactive = Color(0xFFE9E9EB);
}

/// Modern iOS-style payment bottom sheet
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
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: PaymentSheetColors.sheetBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 36.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: PaymentSheetColors.border,
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
              ),
              // Header
              _buildHeader(context),
              // Content
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: PaymentSheetColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: PaymentSheetColors.secondaryText,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Close button
          GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: PaymentSheetColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: PaymentSheetColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern iOS-style coupon input section
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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: PaymentSheetColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: PaymentSheetColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'COUPON'.tr(context).toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: PaymentSheetColors.secondaryText,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: PaymentSheetColors.sheetBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'OPTIONAL'.tr(context).toLowerCase(),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: PaymentSheetColors.tertiaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: PaymentSheetColors.sheetBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: PaymentSheetColors.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'ENTER_COUPON_HERE'.tr(context),
                hintStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: PaymentSheetColors.tertiaryText,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: InputBorder.none,
                suffixIcon: _buildSuffixIcon(),
              ),
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
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

/// Modern iOS-style amount display
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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaymentSheetColors.accent,
            PaymentSheetColors.accent.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: PaymentSheetColors.accent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? 'AMOUNT_PAYABLE'.tr(context),
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Row(
            children: [
              if (hasDiscount) ...[
                Text(
                  Utils.formatPrice(originalAmount!),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.6),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                Utils.formatPrice(amount),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Modern iOS-style payment method card
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
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? PaymentSheetColors.accentLight
              : PaymentSheetColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? PaymentSheetColors.accent
                : PaymentSheetColors.divider,
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: PaymentSheetColors.accent.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? PaymentSheetColors.accent.withOpacity(0.1)
                    : PaymentSheetColors.sheetBackground,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath!,
                        width: 24.w,
                        height: 24.w,
                        color: isSelected
                            ? PaymentSheetColors.accent
                            : PaymentSheetColors.secondaryText,
                      )
                    : Icon(
                        icon ?? Icons.account_balance_wallet_outlined,
                        size: 24.sp,
                        color: isSelected
                            ? PaymentSheetColors.accent
                            : PaymentSheetColors.secondaryText,
                      ),
              ),
            ),
            SizedBox(width: 14.w),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? PaymentSheetColors.accent
                          : PaymentSheetColors.primaryText,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
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
                activeColor: PaymentSheetColors.switchActive,
                trackColor: PaymentSheetColors.switchInactive,
                onChanged: (value) {
                  onToggle?.call(value);
                  onTap();
                },
              )
            else if (prefix != null)
              prefix!
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? PaymentSheetColors.accent
                        : PaymentSheetColors.border,
                    width: isSelected ? 7 : 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Modern iOS-style section header
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
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: PaymentSheetColors.secondaryText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Modern iOS-style primary button
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
        margin: EdgeInsets.all(16.w),
        height: 56.h,
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    PaymentSheetColors.accent,
                    PaymentSheetColors.accent.withOpacity(0.9),
                  ],
                )
              : null,
          color: enabled ? null : PaymentSheetColors.divider,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: PaymentSheetColors.accent.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : PaymentSheetColors.tertiaryText,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Modern payment methods list container
class ModernPaymentMethodsList extends StatelessWidget {
  const ModernPaymentMethodsList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
