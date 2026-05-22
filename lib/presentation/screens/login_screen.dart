import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      if (next.isAuthenticated) context.go('/dashboard');
    });
    final authState = ref.watch(authStateProvider);

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
                  if (authState.isLoading) const CircularProgressIndicator()
                  else _LoginError(error: authState.error),
                  const SizedBox(height: 24),
                  _LoginButton(isLoading: authState.isLoading),
                  const SizedBox(height: 24),
                  const Text('Powered by Strava', style: TextStyle(color: AppColors.gray500, fontWeight: FontWeight.bold)),
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
    return Column(children: [
      const ImageIcon(AssetImage('assets/icons/Icon.png'), size: 100, color: AppColors.brandOrange),
      const SizedBox(height: 32),
      Text('Teman Lari', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
      const SizedBox(height: 16),
      Text('Analyze your running history and generate personalized training plans',
          style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
    ]);
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
      child: Text(error!, textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error)),
    );
  }
}

class _LoginButton extends ConsumerWidget {
  final bool isLoading;
  const _LoginButton({required this.isLoading});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: isLoading ? null : () => ref.read(authStateProvider.notifier).login(),
      icon: const Icon(Icons.login),
      label: const Text('Connect with Strava'),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
    );
  }
}
