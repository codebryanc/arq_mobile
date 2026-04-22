import 'package:flutter/material.dart';

import 'package:arq_mobile/features/home/presentation/widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Welcome Message
            HeaderWidget()
          ]
        )
      ));
  }
}
