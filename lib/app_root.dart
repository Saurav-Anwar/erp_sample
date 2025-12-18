import 'package:erp_sample/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_data_providers.dart';
import 'splash.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppDataProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      // transitionBuilder: (child, animation) =>
      //     SlideTransition(position: animation.drive(
      //       Tween<Offset>(
      //         begin: const Offset(0, 1),
      //         end: Offset.zero,
      //       ),
      //     )),
      child: app.isLoading
          ? const SplashScreen()
          : !app.hasData
          ? const Scaffold(
              body: Center(
                child: Text('No data found'),
              ),
            )
          : app.error != null
          ? Scaffold(
              body: Center(
                child: Text(app.error!),
              ),
            )
          : const MainScreen(),
    );

  }
}
