class AppStrings {
  AppStrings._();

  // App & Titles
  static const String appTitle = 'Catch the Falling Tiles';
  static const String gameTitle = 'Catch the Falling Tiles';

  // Start Screen
  static const String instructions =
      'Drag anywhere, or use ← → / A D, to move the basket.\n'
      'Catch tiles for points. Miss 3 and it\'s game over.';
  static const String startButton = 'Start';

  // HUD
  static const String scorePrefix = 'Score: ';
  static String formatScore(int score) => '$scorePrefix$score';
  static const String highScorePrefix = 'Best: ';
  static String formatHighScore(int score) => '$highScorePrefix$score';

  // Game Over Screen
  static const String gameOver = 'Game Over';
  static const String finalScorePrefix = 'Final score: ';
  static String formatFinalScore(int score) => '$finalScorePrefix$score';
  static const String newHighScore = '🎉 NEW HIGH SCORE! 🎉';
  static const String playAgainButton = 'Play Again';

  // Navigation & General
  static const String errorPageTitle = 'Page Not Found';
  static const String backToGame = 'Back to Game';

  // Overlay Identifiers
  static const String overlayStart = 'start';
  static const String overlayHud = 'hud';
  static const String overlayGameOver = 'gameOver';
}
