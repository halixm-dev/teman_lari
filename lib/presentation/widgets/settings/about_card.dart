import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Teman Lari v1.0.0'),
            const SizedBox(height: 4),
            const Text('Built with Flutter & Riverpod'),
            const SizedBox(height: 8),
            const Text(
              'Powered by Strava',
              style: TextStyle(
                color: AppColors.gray500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
