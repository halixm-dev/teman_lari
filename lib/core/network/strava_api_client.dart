import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/token_storage.dart';
import '../errors/exceptions.dart';

class StravaApiClient {
  final TokenStorage _tokenStorage;
  final StravaAuthDataSource _authDataSource;
  final http.Client _httpClient;

  StravaApiClient(this._tokenStorage, this._authDataSource, this._httpClient);

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? params}) async {
    final token = await _getValidToken();
    final uri = Uri.https('www.strava.com', '/api/v3/$endpoint', params);

    final response = await _httpClient.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw StravaApiException(response.statusCode, response.body);
  }

  Future<List<dynamic>> getList(String endpoint,
      {Map<String, String>? params}) async {
    final token = await _getValidToken();
    final uri = Uri.https('www.strava.com', '/api/v3/$endpoint', params);

    final response = await _httpClient.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw StravaApiException(response.statusCode, response.body);
  }

  Future<String> _getValidToken() async {
    var tokens = await _tokenStorage.getTokens();
    if (tokens == null) throw UnauthenticatedException();

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (tokens.expiresAt - now < 60) {
      tokens = await _authDataSource.refreshToken(tokens.refreshToken);
      await _tokenStorage.saveTokens(tokens);
    }

    return tokens.accessToken;
  }
}
