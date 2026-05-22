import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/strava_api_client.dart';
import '../../data/datasources/preferences_storage.dart';
import '../../data/datasources/strava_activity_datasource.dart';
import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/token_storage.dart';

part 'core_provider.g.dart';

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(() => client.close());
  return client;
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@Riverpod(keepAlive: true)
PreferencesStorage preferencesStorage(Ref ref) {
  return PreferencesStorage();
}

@Riverpod(keepAlive: true)
StravaAuthDataSource stravaAuthDataSource(Ref ref) {
  return StravaAuthDataSource(ref.read(httpClientProvider));
}

@Riverpod(keepAlive: true)
StravaApiClient stravaApiClient(Ref ref) {
  return StravaApiClient(
    ref.read(tokenStorageProvider),
    ref.read(stravaAuthDataSourceProvider),
    ref.read(httpClientProvider),
  );
}

@Riverpod(keepAlive: true)
StravaActivityDataSource stravaActivityDataSource(Ref ref) {
  return StravaActivityDataSource(ref.read(stravaApiClientProvider));
}
