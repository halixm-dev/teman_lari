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

  int? _storedRestingHr;
  int? _storedMaxHr;
  bool _isSaving = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _load();
    _restingHrController.addListener(_onFieldChanged);
    _maxHrController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _restingHrController.removeListener(_onFieldChanged);
    _maxHrController.removeListener(_onFieldChanged);
    _restingHrController.dispose();
    _maxHrController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await ref.read(hrPreferencesProvider.future);
    _restingHrController.removeListener(_onFieldChanged);
    _maxHrController.removeListener(_onFieldChanged);

    _restingHrController.text = prefs.restingHr.toString();
    _storedRestingHr = prefs.restingHr;
    
    final maxStr = prefs.maxHr?.toString() ?? '';
    _maxHrController.text = maxStr;
    _storedMaxHr = prefs.maxHr;
    
    _storedAge = prefs.age;

    _restingHrController.addListener(_onFieldChanged);
    _maxHrController.addListener(_onFieldChanged);

    if (mounted) setState(() {});
  }

  void _onFieldChanged() {
    final restingText = _restingHrController.text.trim();
    final maxText = _maxHrController.text.trim();

    String? restingError;
    if (restingText.isNotEmpty) {
      final val = int.tryParse(restingText);
      if (val == null || val < 30 || val > 120) {
        restingError = 'Enter a value between 30–120';
      }
    }

    String? maxError;
    if (maxText.isNotEmpty) {
      final val = int.tryParse(maxText);
      if (val == null || val < 100 || val > 250) {
        maxError = 'Enter a value between 100–250';
      }
    }

    // Cross-validation: Resting HR must be less than Max HR - 20
    if (restingError == null && maxError == null) {
      final maxHr = getEffectiveMaxHr();
      final restingHr = getEffectiveRestingHr(maxHr);
      if (restingHr > maxHr - 20) {
        restingError = 'Resting HR must be at least 20 bpm below Max HR';
      }
    }

    setState(() {
      _restingHrError = restingError;
      _maxHrError = maxError;
    });
  }

  int getEffectiveMaxHr() {
    final text = _maxHrController.text.trim();
    final val = int.tryParse(text);
    if (val != null && val >= 100 && val <= 250) {
      return val;
    }
    if (_storedAge != null) {
      return 220 - _storedAge!;
    }
    return 190;
  }

  int getEffectiveRestingHr(int maxHr) {
    final text = _restingHrController.text.trim();
    final val = int.tryParse(text);
    if (val != null && val >= 30 && val <= 120) {
      return val.clamp(30, maxHr - 20);
    }
    return 60;
  }

  bool _hasChanges() {
    final restingText = _restingHrController.text.trim();
    final maxText = _maxHrController.text.trim();

    final currentResting = int.tryParse(restingText);
    final currentMax = int.tryParse(maxText);

    final effectiveStoredResting = _storedRestingHr ?? 60;
    final effectiveCurrentResting = currentResting ?? 60;

    final changedResting = effectiveCurrentResting != effectiveStoredResting;
    final changedMax = currentMax != _storedMaxHr;

    return changedResting || changedMax;
  }

  Future<void> _saveChanges() async {
    if (_restingHrError != null || _maxHrError != null) return;

    setState(() {
      _isSaving = true;
      _showSuccess = false;
    });

    final restingText = _restingHrController.text.trim();
    final maxText = _maxHrController.text.trim();

    try {
      final preferencesNotifier = ref.read(hrPreferencesProvider.notifier);

      if (restingText.isEmpty) {
        await preferencesNotifier.clearRestingHr();
      } else {
        final parsed = int.tryParse(restingText);
        if (parsed != null) {
          await preferencesNotifier.saveRestingHr(parsed);
        }
      }

      if (maxText.isEmpty) {
        await preferencesNotifier.clearMaxHr();
      } else {
        final parsed = int.tryParse(maxText);
        if (parsed != null) {
          await preferencesNotifier.saveMaxHr(parsed);
        }
      }

      // Reload stored values to reset "Save Changes" button state
      final prefs = await ref.read(hrPreferencesProvider.future);
      _storedRestingHr = prefs.restingHr;
      _storedMaxHr = prefs.maxHr;

      setState(() {
        _isSaving = false;
        _showSuccess = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _showSuccess = false);
        }
      });
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> _calculatePreviewZones() {
    final maxHr = getEffectiveMaxHr();
    final restingHr = getEffectiveRestingHr(maxHr);
    final hrr = maxHr - restingHr;

    const boundaries = [0.60, 0.70, 0.80, 0.90];
    const labels = [
      'Zone 1 - Recovery',
      'Zone 2 - Aerobic Base',
      'Zone 3 - Tempo',
      'Zone 4 - Threshold',
      'Zone 5 - VO2max',
    ];
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      AppColors.brandOrange,
      Colors.red,
    ];

    return List.generate(5, (i) {
      final minBpm =
          i == 0 ? restingHr : (restingHr + hrr * boundaries[i - 1]).round();
      final maxBpm =
          i == 4 ? maxHr : (restingHr + hrr * boundaries[i]).round();
      return {
        'label': labels[i],
        'min': minBpm,
        'max': maxBpm,
        'color': colors[i],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ConstrainedContent(
        child: ListView(
          children: [
            _buildHeartRateCard(),
            _buildZonesPreviewCard(),
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
          ],
        ),
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
            Row(
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
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _restingHrController,
              label: 'Resting Heart Rate (bpm)',
              hint: 'blank = auto (60)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.favorite_border,
              errorText: _restingHrError,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _maxHrController,
              label: 'Max Heart Rate (bpm)',
              hint: _buildMaxHrHint(),
              keyboardType: TextInputType.number,
              prefixIcon: Icons.bolt,
              errorText: _maxHrError,
            ),
            if (_storedAge != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.gray500),
                  const SizedBox(width: 4),
                  const Text(
                    'Age (from Strava): ',
                    style: TextStyle(color: AppColors.gray700),
                  ),
                  Text(
                    '$_storedAge yrs',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildZonesPreviewCard() {
    final zones = _calculatePreviewZones();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Heart Rate Zones Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Icon(Icons.show_chart, color: AppColors.brandOrange),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Real-time estimation of heart rate training zones using the Karvonen formula (Heart Rate Reserve). These zones will be applied to your analysis and workouts upon saving.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray500,
              ),
            ),
            const SizedBox(height: 16),
            ...zones.map((zone) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          zone['label'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${zone['min']} - ${zone['max']} bpm',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.brandOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: zone['color'].withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 1.0,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: zone['color'],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
      keyboardType: keyboardType,
    );
  }

  String _buildMaxHrHint() {
    if (_storedAge != null) {
      final formula = 220 - _storedAge!;
      return 'blank = auto (220-age: $formula)';
    }
    return 'blank = auto (190)';
  }

  Widget _buildSaveButton() {
    final hasChanges = _hasChanges();
    final hasError = _restingHrError != null || _maxHrError != null;
    final canSave = hasChanges && !hasError && !_isSaving;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: canSave ? _saveChanges : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          disabledBackgroundColor: AppColors.gray200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _showSuccess
                ? const Row(
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
                  )
                : Text(
                    'Save Changes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: canSave ? Colors.white : AppColors.gray500,
                    ),
                  ),
      ),
    );
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
