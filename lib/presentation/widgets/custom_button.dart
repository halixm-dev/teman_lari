import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';


enum ButtonVariant { primary, secondary, ghost, danger, disabled }
enum ButtonSize { sm, md, lg, xl }

class CustomButton extends StatelessWidget {
  final String label;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = variant == ButtonVariant.disabled || isLoading;

    final colors = _resolveColors();
    final dims = _resolveDimensions();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: dims.height,
      constraints: BoxConstraints(minWidth: dims.height * 2),
      decoration: BoxDecoration(
        color: colors.background,
        border: colors.border != null
            ? Border.all(color: colors.border!, width: 2)
            : null,
        borderRadius: BorderRadius.circular(dims.radius),
        boxShadow: isDisabled ? null : AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(dims.radius),
          onTap: isDisabled ? null : onPressed,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dims.paddingH,
                  vertical: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        width: dims.fontSize + 4,
                        height: dims.fontSize + 4,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.text,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leadingIcon != null) ...[
                            Icon(leadingIcon, size: dims.fontSize + 2, color: colors.text),
                            const SizedBox(width: AppSpacing.space2),
                          ],
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: dims.fontSize,
                              fontWeight: dims.fontWeight,
                              color: colors.text,
                            ),
                          ),
                          if (trailingIcon != null) ...[
                            const SizedBox(width: AppSpacing.space2),
                            Icon(trailingIcon, size: dims.fontSize + 2, color: colors.text),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _Colors _resolveColors() {
    if (isLoading || variant == ButtonVariant.disabled) {
      return _Colors(
        background: AppColors.gray100,
        text: AppColors.gray300,
        border: null,
      );
    }
    switch (variant) {
      case ButtonVariant.primary:
        return _Colors(
          background: AppColors.brandOrange,
          text: AppColors.white,
          border: null,
        );
      case ButtonVariant.secondary:
        return _Colors(
          background: Colors.transparent,
          text: AppColors.brandOrange,
          border: AppColors.brandOrange,
        );
      case ButtonVariant.ghost:
        return _Colors(
          background: Colors.transparent,
          text: AppColors.gray700,
          border: AppColors.gray300,
        );
      case ButtonVariant.danger:
        return _Colors(
          background: AppColors.danger,
          text: AppColors.white,
          border: null,
        );
      case ButtonVariant.disabled:
        return _Colors(
          background: AppColors.gray100,
          text: AppColors.gray300,
          border: null,
        );
    }
  }

  _Dimensions _resolveDimensions() {
    switch (size) {
      case ButtonSize.sm:
        return _Dimensions(height: 32, paddingH: 12, fontSize: 13, fontWeight: FontWeight.w500, radius: AppSpacing.radiusMd);
      case ButtonSize.md:
        return _Dimensions(height: 40, paddingH: 16, fontSize: 14, fontWeight: FontWeight.w600, radius: AppSpacing.radiusMd);
      case ButtonSize.lg:
        return _Dimensions(height: 48, paddingH: 24, fontSize: 16, fontWeight: FontWeight.w600, radius: AppSpacing.radiusMd);
      case ButtonSize.xl:
        return _Dimensions(height: 56, paddingH: 32, fontSize: 18, fontWeight: FontWeight.w700, radius: AppSpacing.radiusLg);
    }
  }
}

class _Colors {
  final Color background;
  final Color text;
  final Color? border;
  _Colors({required this.background, required this.text, this.border});
}

class _Dimensions {
  final double height;
  final double paddingH;
  final double fontSize;
  final FontWeight fontWeight;
  final double radius;
  _Dimensions({
    required this.height,
    required this.paddingH,
    required this.fontSize,
    required this.fontWeight,
    required this.radius,
  });
}
