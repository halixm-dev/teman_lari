class ApiConstants {
  static const String stravaClientId =
      String.fromEnvironment('STRAVA_CLIENT_ID');
  static const String stravaClientSecret =
      String.fromEnvironment('STRAVA_CLIENT_SECRET');
  static const String stravaRedirectUri =
      String.fromEnvironment('STRAVA_REDIRECT_URI');
  static const String stravaBaseUrl = 'https://www.strava.com/api/v3';
  static const String stravaAuthUrl = 'https://www.strava.com/oauth/authorize';
  static const String stravaTokenUrl = 'https://www.strava.com/oauth/token';
}
