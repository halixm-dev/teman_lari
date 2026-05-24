// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_coach_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(voiceCoach)
final voiceCoachProvider = VoiceCoachProvider._();

final class VoiceCoachProvider
    extends
        $FunctionalProvider<
          VoiceCoachService,
          VoiceCoachService,
          VoiceCoachService
        >
    with $Provider<VoiceCoachService> {
  VoiceCoachProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceCoachProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceCoachHash();

  @$internal
  @override
  $ProviderElement<VoiceCoachService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VoiceCoachService create(Ref ref) {
    return voiceCoach(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceCoachService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceCoachService>(value),
    );
  }
}

String _$voiceCoachHash() => r'fb399e31d414d6d349389d456d30cae2587330da';
