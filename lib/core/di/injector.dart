import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/game/data/datasources/game_local_datasource.dart';
import '../../features/game/data/datasources/game_remote_datasource.dart';
import '../../features/game/data/repositories/game_repository_impl.dart';
import '../../features/game/domain/repositories/game_repository.dart';
import '../../features/game/domain/usecases/get_game_stats_usecase.dart';
import '../../features/game/domain/usecases/get_high_score_usecase.dart';
import '../../features/game/domain/usecases/save_game_stats_usecase.dart';
import '../../features/game/domain/usecases/save_high_score_usecase.dart';
import '../../features/game/presentation/cubit/game_cubit.dart';
import '../audio/audio_service.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initDependencies({SharedPreferences? mockPrefs}) async {
  // External
  final sharedPreferences = mockPrefs ?? await SharedPreferences.getInstance();
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  // Core
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => const NetworkInfoImpl());
  }

  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(client: sl<http.Client>()),
    );
  }

  if (!sl.isRegistered<AudioService>()) {
    sl.registerLazySingleton<AudioService>(() => FlameAudioServiceImpl());
  }

  // Data Sources
  if (!sl.isRegistered<GameLocalDataSource>()) {
    sl.registerLazySingleton<GameLocalDataSource>(
      () => GameLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
    );
  }

  if (!sl.isRegistered<GameRemoteDataSource>()) {
    sl.registerLazySingleton<GameRemoteDataSource>(
      () => GameRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
  }

  // Repositories
  if (!sl.isRegistered<GameRepository>()) {
    sl.registerLazySingleton<GameRepository>(
      () => GameRepositoryImpl(
        localDataSource: sl<GameLocalDataSource>(),
        remoteDataSource: sl<GameRemoteDataSource>(),
      ),
    );
  }

  // Use Cases
  if (!sl.isRegistered<GetHighScoreUseCase>()) {
    sl.registerLazySingleton<GetHighScoreUseCase>(
      () => GetHighScoreUseCase(sl<GameRepository>()),
    );
  }

  if (!sl.isRegistered<SaveHighScoreUseCase>()) {
    sl.registerLazySingleton<SaveHighScoreUseCase>(
      () => SaveHighScoreUseCase(sl<GameRepository>()),
    );
  }

  if (!sl.isRegistered<GetGameStatsUseCase>()) {
    sl.registerLazySingleton<GetGameStatsUseCase>(
      () => GetGameStatsUseCase(sl<GameRepository>()),
    );
  }

  if (!sl.isRegistered<SaveGameStatsUseCase>()) {
    sl.registerLazySingleton<SaveGameStatsUseCase>(
      () => SaveGameStatsUseCase(sl<GameRepository>()),
    );
  }

  // Blocs / Cubits
  if (!sl.isRegistered<GameCubit>()) {
    sl.registerFactory<GameCubit>(
      () => GameCubit(
        getHighScoreUseCase: sl<GetHighScoreUseCase>(),
        saveHighScoreUseCase: sl<SaveHighScoreUseCase>(),
        saveGameStatsUseCase: sl<SaveGameStatsUseCase>(),
        audioService: sl<AudioService>(),
      ),
    );
  }
}
