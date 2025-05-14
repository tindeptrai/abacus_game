class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Game endpoints
  static const String gameSettings = '/game/settings';
  static const String gameResults = '/game/results';
  static const String leaderboard = '/game/leaderboard';

  // Helper method to build URLs with parameters
  static String buildUrl(String endpoint, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return endpoint;

    final queryParams = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return '$endpoint?$queryParams';
  }
}
