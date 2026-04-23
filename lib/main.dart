import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/di/dependency_injection.dart';
import 'package:arq_mobile/core/l10n/app_localizations_es.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/movies_by_category/presentation/bloc/movies_by_category_bloc.dart';
import 'package:arq_mobile/features/popular_movies/presentation/bloc/popular_movies_bloc.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init(
    defaultServerError: AppLocalizationsEs().errorUnknown,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => sl<HomeBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => sl<CategoryBloc>(),
        ),
        BlocProvider<PopularMoviesBloc>(
          create: (BuildContext context) => sl<PopularMoviesBloc>(),
        ),
        BlocProvider<MoviesByCategoryBloc>(
          create: (BuildContext context) => sl<MoviesByCategoryBloc>(),
        ),
      ],
      child: const App(),
    ),
  );
}
