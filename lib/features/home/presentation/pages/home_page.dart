import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/features/category/presentation/pages/category_page.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:arq_mobile/features/home/presentation/widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  // [Constructor]
  const HomePage({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 14),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) => CategoryPage(
                      viewMode: state is HomeChipsView
                          ? CategoryViewMode.chips
                          : CategoryViewMode.list,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
