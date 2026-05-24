import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_run_rounded,
                    color: AppColors.brandOrange,
                    size: 28,
                  ),
                ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teman Lari',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'v1.0.0 • Production Build',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.gray500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: isDark ? AppColors.dividerDark : AppColors.gray200),
            const SizedBox(height: 16),
            _AboutInfoRow(
              icon: Icons.code_rounded,
              label: 'Built with',
              value: 'Flutter & Riverpod',
            ),
            const SizedBox(height: 12),
            _AboutInfoRow(
              icon: Icons.api_rounded,
              label: 'Strava API Status',
              value: 'Active Connected',
              valueColor: AppColors.success,
              showIndicator: true,
            ),
            const SizedBox(height: 12),
            _AboutInfoRow(
              icon: Icons.security_rounded,
              label: 'Data Storage',
              value: '100% Local & Secure',
            ),
            const SizedBox(height: 20),
            Divider(color: isDark ? AppColors.dividerDark : AppColors.gray200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TextLink(
                  label: 'Privacy Policy',
                  onTap: () => _showPolicySheet(
                    context,
                    'Privacy Policy',
                    _privacyContent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: isDark
                      ? AppColors.surfaceTertiaryDark
                      : AppColors.gray300,
                ),
                _TextLink(
                  label: 'Terms of Service',
                  onTap: () => _showPolicySheet(
                    context,
                    'Terms of Service',
                    _termsContent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPolicySheet(BuildContext context, String title, String content) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child:
                Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceTertiaryDark
                                  : AppColors.gray300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.gray700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.brandOrange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Got it',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fade(duration: 250.ms)
                    .slideY(begin: 0.08, curve: Curves.easeOutCubic),
          ),
        );
      },
    );
  }

  static const _privacyContent =
      'Your privacy is our ultimate priority. Teman Lari only requests access to your Strava activity list and profile info to calibrate your personalized training cycles. All parsed statistics, paces, heart rate data, and training day configurations are stored 100% locally on your device.\n\nWe do not operate external databases, track your location, or transmit your biological metrics to any third parties. Disconnecting your Strava account in the settings will instantly purge all local caches from your device.';

  static const _termsContent =
      'Welcome to Teman Lari. By using this application and connecting your Strava account, you agree that your training load estimation, heart rate boundaries, and run pacing plans are generated based on mathematical athletic training models (Karvonen & Daniels Daniels Cooper formulas).\n\nThese projections are for physical conditioning and training information purposes only. Always consult with a certified healthcare practitioner or sports coach before starting any high-intensity athletic training plans or physical workouts. Use at your own risk.';
}

class _AboutInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showIndicator;

  const _AboutInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.textTertiaryDark : AppColors.gray500,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (showIndicator) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: valueColor ?? AppColors.brandOrange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color:
                valueColor ??
                (isDark ? AppColors.textPrimaryDark : AppColors.gray900),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TextLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _TextLink({required this.label, required this.onTap});

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isHovered
                ? AppColors.brandOrangeLight
                : (isDark ? AppColors.textSecondaryDark : AppColors.gray700),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            decoration: TextDecoration.underline,
            decorationColor: _isHovered
                ? AppColors.brandOrangeLight
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
