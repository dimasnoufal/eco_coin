import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.emeraldDefault,
          foregroundColor: AppColor.neutralWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          disabledBackgroundColor: AppColor.neutral30,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.neutralWhite,
                  ),
                ),
              )
            : Text(
                text,
                style: AppColor.semibold.copyWith(
                  fontSize: 16,
                  color: AppColor.neutralWhite,
                ),
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final String? iconAsset;
  final Widget? icon;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 50,
    this.borderRadius = 12,
    this.iconAsset,
    this.icon,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
  });

  factory SecondaryButton.google({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    double height = 50,
    String? iconAsset = 'assets/images/ic_google.png',
  }) {
    return SecondaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      height: height,
      iconAsset: iconAsset,
      borderColor: AppColor.neutral20,
      backgroundColor: AppColor.neutralWhite,
      textColor: AppColor.neutralBlack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? AppColor.neutral20, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: backgroundColor ?? AppColor.neutralWhite,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColor.neutralBlack,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconAsset != null)
                    Image.asset(iconAsset!, width: 20, height: 20)
                  else if (icon != null)
                    icon!,
                  if (iconAsset != null || icon != null)
                    const SizedBox(width: 12),
                  Text(
                    text,
                    style: AppColor.medium.copyWith(
                      fontSize: 16,
                      color: textColor ?? AppColor.neutralBlack,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
