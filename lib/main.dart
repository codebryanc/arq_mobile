import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/di/dependency_injection.dart';
import 'package:arq_mobile/features/category/presentation/bloc/category_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => sl<HomeBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => sl<CategoryBloc>(),
        ),
      ],
      child: const App(),
    ),
  );
}
