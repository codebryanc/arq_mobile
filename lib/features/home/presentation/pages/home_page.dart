import 'package:flutter/material.dart';

import 'package:arq_mobile/features/home/presentation/widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 20),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Widget (Welcome widget)
                HeaderWidget()
              ]
            )
          )
        ]
      ),
    );
  }
}
