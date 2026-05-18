import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/responsive.dart';
import '../providers/activities_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _restingHrController = TextEditingController();
  final _maxHrController = TextEditingController();
  String? _restingHrError;
  String? _maxHrError;
  int? _storedAge;
  int _hrZoneWeeks = 12;

  @override
  void dispose() {
    _restingHrController.dispose();
    _maxHrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ConstrainedContent(
        child: ListView(children: [
          _buildHeartRateCard(),
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Disconnect Strava'),
              subtitle: const Text('Remove access to your Strava account'),
              onTap: () => _showLogoutDialog(context, ref),
            ),
          ),
          Card(
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
          ),
        ]),
      ),
    );
  }

  Widget _buildHeartRateCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heart Rate Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _restingHrController,
              label: 'Resting Heart Rate (bpm)',
              hint: '65',
              keyboardType: TextInputType.number,
              errorText: _restingHrError,
              onChanged: (v) => _saveRestingHr(v),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _maxHrController,
              label: 'Max Heart Rate (bpm)',
              hint: _buildMaxHrHint(),
              errorText: _maxHrError,
              keyboardType: TextInputType.number,
              onChanged: (v) => _saveMaxHr(v),
            ),
            if (_storedAge != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Age (from Strava): '),
                  Text(
                    '$_storedAge yrs',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('HR Zone Analysis Window: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _hrZoneWeeks,
                  items: const [
                    DropdownMenuItem(value: 4, child: Text('4 weeks')),
                    DropdownMenuItem(value: 8, child: Text('8 weeks')),
                    DropdownMenuItem(value: 12, child: Text('12 weeks (Recommended)')),
                    DropdownMenuItem(value: 26, child: Text('26 weeks')),
                    DropdownMenuItem(value: 52, child: Text('52 weeks')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _hrZoneWeeks = v);
                    ref.read(preferencesStorageProvider).saveHrZoneWeeks(v);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  String _buildMaxHrHint() {
    if (_storedAge != null) {
      final formula = 220 - _storedAge!;
      return 'blank = auto (220-age: $formula)';
    }
    return 'blank = auto (190)';
  }

  Future<void> _saveRestingHr(String value) async {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 30 || parsed > 120) {
      if (value.isNotEmpty) {
        setState(() => _restingHrError = 'Enter a value between 30–120');
      } else {
        setState(() => _restingHrError = null);
      }
      return;
    }
    setState(() => _restingHrError = null);
    await ref.read(preferencesStorageProvider).saveRestingHr(parsed);
  }

  Future<void> _saveMaxHr(String value) async {
    final storage = ref.read(preferencesStorageProvider);
    if (value.isEmpty) {
      setState(() => _maxHrError = null);
      await storage.clearMaxHr();
      return;
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 100 || parsed > 250) {
      setState(() => _maxHrError = 'Enter a value between 100–250');
      return;
    }
    setState(() => _maxHrError = null);
    await storage.saveMaxHr(parsed);
  }

  Future<void> _load() async {
    final prefs = await ref.read(preferencesStorageProvider).getPreferences();
    _restingHrController.text = prefs.restingHr.toString();
    final maxStr = prefs.maxHr?.toString() ?? '';
    _maxHrController.text = maxStr;
    _storedAge = prefs.age;
    _hrZoneWeeks = prefs.hrZoneWeeks;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Strava'),
        content: const Text(
          'Are you sure you want to disconnect your Strava account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.pop(context);
            },
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
