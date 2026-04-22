import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:arq_mobile/core/network/dio_client.dart';
import 'package:arq_mobile/features/category/data/datasources/category_remote_datasource.dart';
import 'package:arq_mobile/features/category/data/repositories/category_repository_impl.dart';
import 'package:arq_mobile/features/category/domain/repositories/category_repository.dart';
import 'package:arq_mobile/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/popular_movies/data/datasources/popular_movies_remote_datasource.dart';
import 'package:arq_mobile/features/popular_movies/data/repositories/popular_movies_repository_impl.dart';
import 'package:arq_mobile/features/popular_movies/domain/repositories/popular_movies_repository.dart';
import 'package:arq_mobile/features/popular_movies/domain/usecases/get_popular_movies_usecase.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_event.dart';

// Dependency Injection setup using GetIt
final sl = GetIt.instance;

class DependencyInjection {
  // [Constructor]
  DependencyInjection._();

  // [Methods]
  static void init({required String defaultServerError}) {
    // Network
    sl.registerLazySingleton<Dio>(
      () => DioClient.create(defaultServerError: defaultServerError),
    );

    // Data sources
    sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(dio: sl()),
    );
    sl.registerLazySingleton<PopularMoviesRemoteDataSource>(
      () => PopularMoviesRemoteDataSourceImpl(dio: sl()),
    );

    // Repositories
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<PopularMoviesRepository>(
      () => PopularMoviesRepositoryImpl(remoteDataSource: sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));

    // BLoCs
    sl.registerFactory<HomeBloc>(() => HomeBloc());
    sl.registerFactory<CategoryBloc>(
      () => CategoryBloc(getCategories: sl())..add(const LoadCategories()),
    );
    sl.registerFactory<PopularMoviesBloc>(
      () => PopularMoviesBloc(getPopularMovies: sl())
        ..add(const LoadPopularMovies()),
    );
  }
}
