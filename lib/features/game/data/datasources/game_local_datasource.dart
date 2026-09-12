import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/game_stats_model.dart';

abstract class GameLocalDataSource {
  Future<int> getHighScore();
  Future<void> saveHighScore(int score);
  Future<GameStatsModel?> getGameStats();
  Future<void> saveGameStats(GameStatsModel stats);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  const GameLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String highScoreKey = 'CACHED_HIGH_SCORE';
  static const String gameStatsKey = 'CACHED_GAME_STATS';

  @override
  Future<int> getHighScore() async {
    try {
      return sharedPreferences.getInt(highScoreKey) ?? 0;
    } catch (e) {
      throw CacheException(message: 'Failed to read high score: $e');
    }
  }

  @override
  Future<void> saveHighScore(int score) async {
    try {
      final current = sharedPreferences.getInt(highScoreKey) ?? 0;
      if (score > current) {
        await sharedPreferences.setInt(highScoreKey, score);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save high score: $e');
    }
  }

  @override
  Future<GameStatsModel?> getGameStats() async {
    try {
      final jsonString = sharedPreferences.getString(gameStatsKey);
      if (jsonString == null) return null;
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return GameStatsModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(message: 'Failed to read game stats: $e');
    }
  }

  @override
  Future<void> saveGameStats(GameStatsModel stats) async {
    try {
      final jsonString = jsonEncode(stats.toJson());
      await sharedPreferences.setString(gameStatsKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save game stats: $e');
    }
  }
}
