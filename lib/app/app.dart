import 'package:flutter/material.dart';
import 'package:schedule_app/app/router/main_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter test',
      routerConfig: mainRouter,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      checkerboardRasterCacheImages: false,
      showPerformanceOverlay: false,
      checkerboardOffscreenLayers: false,
      showSemanticsDebugger: false,
    );
  }
}
