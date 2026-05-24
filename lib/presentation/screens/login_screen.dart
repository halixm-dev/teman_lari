import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/dashboard');
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: ConstrainedContent(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _LoginHeader(),
                  const SizedBox(height: 48),
                  if (authState.isLoading)
                    const CircularProgressIndicator()
                  else
                    _LoginError(error: authState.error),
                  const SizedBox(height: 24),
                  _LoginButton(isLoading: authState.isLoading),
                  const SizedBox(height: 24),
                  const Text(
                    'Powered by Strava',
                    style: TextStyle(
                      color: AppColors.gray500,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fade(delay: 650.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const ImageIcon(
              AssetImage('assets/icons/Icon.png'),
              size: 100,
              color: AppColors.brandOrange,
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(delay: 100.ms, duration: 600.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 32),
        Text(
              'Teman Lari',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fade(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
        const SizedBox(height: 16),
        Text(
              'Analyze your running history and generate personalized training plans',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fade(delay: 350.ms, duration: 600.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
      ],
    );
  }
}

class _LoginError extends StatelessWidget {
  final String? error;
  const _LoginError({this.error});
  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        error!,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    ).animate().fade().shake(hz: 4, curve: Curves.easeInOutCubic);
  }
}

class _LoginButton extends ConsumerWidget {
  final bool isLoading;
  const _LoginButton({required this.isLoading});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  ref.read(authProvider.notifier).login();
                },
          icon: const Icon(Icons.login),
          label: const Text('Connect with Strava'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.brandOrange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
        .animate()
        .fade(delay: 500.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
  }
}
