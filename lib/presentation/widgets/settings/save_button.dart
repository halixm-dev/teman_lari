import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class SettingsSaveButton extends StatelessWidget {
  final bool canSave;
  final bool isSaving;
  final bool showSuccess;
  final VoidCallback? onSave;

  const SettingsSaveButton({
    super.key,
    required this.canSave,
    required this.isSaving,
    required this.showSuccess,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabledBgColor = isDark
        ? AppColors.surfaceTertiaryDark
        : AppColors.gray200;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: canSave ? onSave : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          disabledBackgroundColor: disabledBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isSaving) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    if (showSuccess) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Saved Successfully',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabledTextColor = isDark
        ? AppColors.textTertiaryDark
        : AppColors.gray500;

    return Text(
      'Save Changes',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: canSave ? Colors.white : disabledTextColor,
      ),
    );
  }
}
