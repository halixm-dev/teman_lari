// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stravaAuthUseCase)
final stravaAuthUseCaseProvider = StravaAuthUseCaseProvider._();

final class StravaAuthUseCaseProvider
    extends
        $FunctionalProvider<
          StravaAuthUseCase,
          StravaAuthUseCase,
          StravaAuthUseCase
        >
    with $Provider<StravaAuthUseCase> {
  StravaAuthUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stravaAuthUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stravaAuthUseCaseHash();

  @$internal
  @override
  $ProviderElement<StravaAuthUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StravaAuthUseCase create(Ref ref) {
    return stravaAuthUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StravaAuthUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StravaAuthUseCase>(value),
    );
  }
}

String _$stravaAuthUseCaseHash() => r'12e7f9a8c74b22cf8ef0137dc4f926b09dab1bf8';

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthState> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authNotifierHash() => r'ca44a013d1570cb31a8e1527aa3c0a004138d93e';

abstract class _$AuthNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
