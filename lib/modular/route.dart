
class AppRouteConstants {
  AppRouteConstants._();

  static const String defaultRoute = '/';
  
  static const String homeRoute = '/home';
  static const String settingsRoute = '/settings';
  static const String continueGameRoute = '/continue';
  
  static const String suruRoute = '/suru';
  static const String sudokuLeaderboardRoute = '/leaderboard';

  static const String abacusRoute = '/abacus';
  static const String mathGameRoute = '/mathGame';
  static const String mathGameScreenRoute = '/mathGameScreenRoute';
  static const String abacusGameScreenRoute = '/abacusGameScreenRoute';

  static const String mathGameFullRoute = '$mathGameRoute$mathGameScreenRoute';
  static const String abacusGameFullRoute = '$abacusRoute$abacusGameScreenRoute';
  static const String settingsFullRoute = '$homeRoute$settingsRoute';
  static const String continueGameFullRoute = '$homeRoute$continueGameRoute';
  static const String sudokuLeaderboardFullRoute = '$suruRoute$sudokuLeaderboardRoute';
}
