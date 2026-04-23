import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/theme/app_colors.dart';
import 'package:arq_mobile/core/theme/app_semantic_colors.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:arq_mobile/features/home/presentation/bloc/home_state.dart';

class HeaderWidget extends StatelessWidget {
  // [Constructor]
  const HeaderWidget({super.key});

  // [Methods]
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context)!.homeGreeting,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Connection mode toggle
          IconButton(
            icon: Icon(
              state.isOnline ? Icons.wifi : Icons.wifi_off,
              color: state.isOnline
                  ? Theme.of(context).extension<AppSemanticColors>()!.success
                  : Theme.of(context).extension<AppSemanticColors>()!.error,
            ),
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeToggleConnectionMode()),
          ),
          // View mode toggle
          IconButton(
            icon: Icon(
              state is HomeChipsView ? Icons.view_list : Icons.grid_view,
            ),
            color: AppColors.secondary,
            onPressed: state is HomeChipsView
                ? () => context.read<HomeBloc>().add(const HomeShowList())
                : () => context.read<HomeBloc>().add(const HomeShowChips()),
          ),
        ],
      ),
    );
  }
}
