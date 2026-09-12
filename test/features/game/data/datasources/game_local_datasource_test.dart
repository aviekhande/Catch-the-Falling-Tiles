import 'package:catch_the_falling_tiles/features/game/data/datasources/game_local_datasource.dart';
import 'package:catch_the_falling_tiles/features/game/data/models/game_stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late GameLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = GameLocalDataSourceImpl(sharedPreferences: prefs);
  });

  group('GameLocalDataSource Tests', () {
    test('getHighScore returns 0 by default when no value stored', () async {
      final highScore = await dataSource.getHighScore();
      expect(highScore, 0);
    });

    test('saveHighScore stores score and updates high score only if greater', () async {
      await dataSource.saveHighScore(10);
      expect(await dataSource.getHighScore(), 10);

      // Attempt to save smaller score should not overwrite
      await dataSource.saveHighScore(5);
      expect(await dataSource.getHighScore(), 10);

      // Attempt to save larger score should overwrite
      await dataSource.saveHighScore(20);
      expect(await dataSource.getHighScore(), 20);
    });

    test('saveGameStats and getGameStats serialize and deserialize properly', () async {
      expect(await dataSource.getGameStats(), isNull);

      const stats = GameStatsModel(score: 12, lives: 1, highScore: 18);
      await dataSource.saveGameStats(stats);

      final retrieved = await dataSource.getGameStats();
      expect(retrieved, isNotNull);
      expect(retrieved?.score, 12);
      expect(retrieved?.lives, 1);
      expect(retrieved?.highScore, 18);
    });
  });
}
