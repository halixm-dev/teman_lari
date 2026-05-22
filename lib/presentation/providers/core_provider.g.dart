// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'333b5ea441c82facedda18bb59b7f46d82fd2ce4';

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'23b0f4fbc323ec56119e50446aeaa2c5e3abe772';

@ProviderFor(preferencesStorage)
final preferencesStorageProvider = PreferencesStorageProvider._();

final class PreferencesStorageProvider
    extends
        $FunctionalProvider<
          PreferencesStorage,
          PreferencesStorage,
          PreferencesStorage
        >
    with $Provider<PreferencesStorage> {
  PreferencesStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesStorageHash();

  @$internal
  @override
  $ProviderElement<PreferencesStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreferencesStorage create(Ref ref) {
    return preferencesStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesStorage>(value),
    );
  }
}

String _$preferencesStorageHash() =>
    r'54ec9105ec7b797620d16be1d5547026eec509de';

@ProviderFor(stravaAuthDataSource)
final stravaAuthDataSourceProvider = StravaAuthDataSourceProvider._();

final class StravaAuthDataSourceProvider
    extends
        $FunctionalProvider<
          StravaAuthDataSource,
          StravaAuthDataSource,
          StravaAuthDataSource
        >
    with $Provider<StravaAuthDataSource> {
  StravaAuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stravaAuthDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stravaAuthDataSourceHash();

  @$internal
  @override
  $ProviderElement<StravaAuthDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StravaAuthDataSource create(Ref ref) {
    return stravaAuthDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StravaAuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StravaAuthDataSource>(value),
    );
  }
}

String _$stravaAuthDataSourceHash() =>
    r'9d6cb130f785bf1fcc1e79d80cd56d31774803ae';

@ProviderFor(stravaApiClient)
final stravaApiClientProvider = StravaApiClientProvider._();

final class StravaApiClientProvider
    extends
        $FunctionalProvider<StravaApiClient, StravaApiClient, StravaApiClient>
    with $Provider<StravaApiClient> {
  StravaApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stravaApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stravaApiClientHash();

  @$internal
  @override
  $ProviderElement<StravaApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StravaApiClient create(Ref ref) {
    return stravaApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StravaApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StravaApiClient>(value),
    );
  }
}

String _$stravaApiClientHash() => r'ad341231a241ad419077f6624c08bb86beb7fae8';

@ProviderFor(stravaActivityDataSource)
final stravaActivityDataSourceProvider = StravaActivityDataSourceProvider._();

final class StravaActivityDataSourceProvider
    extends
        $FunctionalProvider<
          StravaActivityDataSource,
          StravaActivityDataSource,
          StravaActivityDataSource
        >
    with $Provider<StravaActivityDataSource> {
  StravaActivityDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stravaActivityDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stravaActivityDataSourceHash();

  @$internal
  @override
  $ProviderElement<StravaActivityDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StravaActivityDataSource create(Ref ref) {
    return stravaActivityDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StravaActivityDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StravaActivityDataSource>(value),
    );
  }
}

String _$stravaActivityDataSourceHash() =>
    r'33053bc115e1a3953ad683120d8fc73e2751bca0';
