import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class HeartRateCard extends StatelessWidget {
  final TextEditingController restingHrController;
  final TextEditingController maxHrController;
  final String? restingHrError;
  final String? maxHrError;
  final int? storedAge;
  final Widget saveButton;
  final String maxHrHint;

  const HeartRateCard({
    super.key,
    required this.restingHrController,
    required this.maxHrController,
    this.restingHrError,
    this.maxHrError,
    this.storedAge,
    required this.saveButton,
    required this.maxHrHint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(),
            const SizedBox(height: 16),
            _buildRestingField(),
            const SizedBox(height: 16),
            _buildMaxField(),
            if (storedAge != null) ...[
              const SizedBox(height: 12),
              _AgeInfo(age: storedAge!),
            ],
            const SizedBox(height: 20),
            saveButton,
          ],
        ),
      ),
    );
  }

  Widget _buildRestingField() {
    return _buildTextField(
      controller: restingHrController,
      label: 'Resting Heart Rate (bpm)',
      hint: 'blank = auto (60)',
      prefixIcon: Icons.favorite_border,
      errorText: restingHrError,
    );
  }

  Widget _buildMaxField() {
    return _buildTextField(
      controller: maxHrController,
      label: 'Max Heart Rate (bpm)',
      hint: maxHrHint,
      prefixIcon: Icons.bolt,
      errorText: maxHrError,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: Icon(prefixIcon, color: AppColors.gray500),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.brandOrange, width: 2),
        ),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
    );
  }
}

class _CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.favorite, color: AppColors.brandOrange),
        const SizedBox(width: 8),
        Text(
          'Heart Rate Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _AgeInfo extends StatelessWidget {
  final int age;

  const _AgeInfo({required this.age});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: AppColors.gray500),
        const SizedBox(width: 4),
        const Text(
          'Age (from Strava): ',
          style: TextStyle(color: AppColors.gray700),
        ),
        Text(
          '$age yrs',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}
