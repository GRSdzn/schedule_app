import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:schedule_app/app/router/scaffold_with_nested_navigation.dart';
import 'package:schedule_app/features/launch_splash/data/repository/group_teacher_repo.dart';
import 'package:schedule_app/features/launch_splash/presentation/bloc/get_data_list_bloc_bloc.dart';
import 'package:schedule_app/features/schedule/presentation/schedule_screen.dart';
import 'package:schedule_app/features/settings/presentation/settings_screen.dart';
import 'package:schedule_app/features/launch_splash/presentation/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey =
    GlobalKey<NavigatorState>(debugLabel: 'HomeScreenShell');
final _shellNavigatorBKey =
    GlobalKey<NavigatorState>(debugLabel: 'ScheduleScreenShell');

final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: const ValueKey('LaunchScreen'),
          child: BlocProvider(
            create: (_) => GetDataListBloc(
                GetGroupsAndTeachersList()), // Создание экземпляра репозитория
            child: const LaunchSplashScreen(),
          ),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              name: 'Schedule',
              path: '/schedule',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: ScheduleScreen(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              name: 'Settings',
              path: '/settings',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: SettingsScreen(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
