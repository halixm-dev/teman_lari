// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HrPreferencesNotifier)
final hrPreferencesProvider = HrPreferencesNotifierProvider._();

final class HrPreferencesNotifierProvider
    extends $AsyncNotifierProvider<HrPreferencesNotifier, HrPreferences> {
  HrPreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hrPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hrPreferencesNotifierHash();

  @$internal
  @override
  HrPreferencesNotifier create() => HrPreferencesNotifier();
}

String _$hrPreferencesNotifierHash() =>
    r'b57409cb24b70d0fbc4aa65cac535399583a0125';

abstract class _$HrPreferencesNotifier extends $AsyncNotifier<HrPreferences> {
  FutureOr<HrPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HrPreferences>, HrPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HrPreferences>, HrPreferences>,
              AsyncValue<HrPreferences>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(athleteName)
final athleteNameProvider = AthleteNameProvider._();

final class AthleteNameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  AthleteNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'athleteNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$athleteNameHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return athleteName(ref);
  }
}

String _$athleteNameHash() => r'af72297fbb5b6421eaf5ce9b89b77ac4acdc5551';
