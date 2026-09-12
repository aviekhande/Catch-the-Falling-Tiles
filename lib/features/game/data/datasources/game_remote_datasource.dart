import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/game_stats_model.dart';
import '../models/high_score_model.dart';

abstract class GameRemoteDataSource {
  Future<void> syncScore(int score);
  Future<void> syncGameStats(GameStatsModel stats);
  Future<List<HighScoreModel>> getLeaderboard();
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  const GameRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> syncScore(int score) async {
    await apiClient.post(
      ApiEndpoints.highScores,
      body: {
        'score': score,
        'recordedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> syncGameStats(GameStatsModel stats) async {
    await apiClient.post(
      ApiEndpoints.syncStats,
      body: stats.toJson(),
    );
  }

  @override
  Future<List<HighScoreModel>> getLeaderboard() async {
    final response = await apiClient.get(ApiEndpoints.leaderboard);
    if (response is List) {
      return response
          .map((item) => HighScoreModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
