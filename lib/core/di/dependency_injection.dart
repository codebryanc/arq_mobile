import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:arq_mobile/core/firebase/remote_config_service.dart';
import 'package:arq_mobile/core/network/dio_client.dart';
import 'package:arq_mobile/features/category/data/datasources/category_local_datasource.dart';
import 'package:arq_mobile/features/category/data/datasources/category_remote_datasource.dart';
import 'package:arq_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/home/data/datasources/view_mode_local_datasource.dart';
import 'package:arq_mobile/features/home/domain/repositories/view_mode_repository.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/get_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_connection_mode_usecase.dart';
import 'package:arq_mobile/features/home/domain/usecases/save_view_mode_usecase.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_local_datasource.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_remote_datasource.dart';
import 'package:arq_mobile/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import 'package:arq_mobile/features/popular_movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_local_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/data/datasources/movies_by_category_remote_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/domain/repositories/movies_by_category_repository.dart';
import 'package:arq_mobile/features/movies_by_category/domain/usecases/get_movies_by_category_usecase.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_local_datasource.dart';
import 'package:arq_mobile/features/movie_detail/data/datasources/movie_detail_remote_datasource.dart';
import 'package:arq_mobile/features/movies_by_category/data/repositories/movies_by_category_repository_impl.dart';
import 'package:arq_mobile/features/category/data/repositories/category_repository_impl.dart';
import 'package:arq_mobile/features/home/data/repositories/view_mode_repository_impl.dart';
import 'package:arq_mobile/features/popular_movies/data/repositories/popular_movies_repository_impl.dart';
import 'package:arq_mobile/features/movie_detail/data/repositories/movie_detail_repository_impl.dart';
import 'package:arq_mobile/features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_cast_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_detail_usecase.dart';
import 'package:arq_mobile/features/movie_detail/domain/usecases/get_movie_images_usecase.dart';
import 'package:arq_mobile/features/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_event.dart';

/// BEGIN: SINGLETON PATTERN (SOLID) ///
///
/// We use Singleton here to avoid multiple instances of the same class
/// and to ensure that we have a single source of truth for our dependencies throughout the app.
///
/// END: SINGLETON PATTERN ///

// Dependency Injection setup using GetIt
final sl = GetIt.instance;

class DependencyInjection {
  // [Constructor]
  DependencyInjection._();

  // [Methods]
  static Future<void> init({required String defaultServerError}) async {
    // Remote Config
    final rc = FirebaseRemoteConfig.instance;
    await rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );
    await rc.fetchAndActivate();
    sl.registerSingleton<RemoteConfigService>(RemoteConfigServiceImpl(rc));

    // Local storage
    final prefs = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(prefs);

    // Network
    sl.registerLazySingleton<Dio>(
      () => DioClient.create(defaultServerError: defaultServerError),
    );

    // Data sources
    sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<PopularMoviesRemoteDataSource>(
      () => PopularMoviesRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<PopularMoviesLocalDataSource>(
      () => PopularMoviesLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<MoviesByCategoryRemoteDataSource>(
      () => MoviesByCategoryRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<MoviesByCategoryLocalDataSource>(
      () => MoviesByCategoryLocalDataSourceImpl(),
    );
    sl.registerLazySingleton<MovieDetailRemoteDataSource>(
      () => MovieDetailRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<MovieDetailLocalDataSource>(
      () => MovieDetailLocalDataSourceImpl(),
    );

    // Repositories
    sl.registerLazySingleton<CategoryRepository>(
      () =>
          CategoryRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );
    sl.registerLazySingleton<PopularMoviesRepository>(
      () => PopularMoviesRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
    sl.registerLazySingleton<MoviesByCategoryRepository>(
      () => MoviesByCategoryRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
    sl.registerLazySingleton<MovieDetailRepository>(
      () => MovieDetailRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
    sl.registerLazySingleton(() => GetMoviesByCategoryUseCase(sl()));
    sl.registerLazySingleton(() => GetMovieDetailUseCase(sl()));
    sl.registerLazySingleton(() => GetMovieCastUseCase(sl()));
    sl.registerLazySingleton(() => GetMovieImagesUseCase(sl()));

    // ViewMode (local)
    sl.registerLazySingleton<ViewModeLocalDataSource>(
      () => ViewModeLocalDataSourceImpl(prefs: sl()),
    );
    sl.registerLazySingleton<ViewModeRepository>(
      () => ViewModeRepositoryImpl(localDataSource: sl()),
    );
    sl.registerLazySingleton(() => GetViewModeUseCase(sl()));
    sl.registerLazySingleton(() => SaveViewModeUseCase(sl()));
    sl.registerLazySingleton(() => GetConnectionModeUseCase(sl()));
    sl.registerLazySingleton(() => SaveConnectionModeUseCase(sl()));

    // BLoCs
    sl.registerFactory<HomeBloc>(
      () => HomeBloc(
        getViewMode: sl(),
        saveViewMode: sl(),
        getConnectionMode: sl(),
        saveConnectionMode: sl(),
      ),
    );
    sl.registerFactory<CategoryBloc>(
      () =>
          CategoryBloc(getCategories: sl())
            ..add(const LoadCategories(isOnline: true)),
    );
    sl.registerFactory<PopularMoviesBloc>(
      () =>
          PopularMoviesBloc(getPopularMovies: sl())
            ..add(const LoadPopularMovies(isOnline: true)),
    );
    sl.registerFactory<MoviesByCategoryBloc>(
      () => MoviesByCategoryBloc(getMoviesByCategory: sl()),
    );
    sl.registerFactory<MovieDetailBloc>(
      () => MovieDetailBloc(
        getMovieDetail: sl(),
        getMovieCast: sl(),
        getMovieImages: sl(),
      ),
    );
  }
}
