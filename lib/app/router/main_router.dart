import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/app/router/scaffold_with_nested_navigation.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/data/repository/group_teacher_repo.dart';
import 'package:schedule_app/presentation/screens/home_screen.dart';
import 'package:schedule_app/presentation/screens/settings_screen.dart';
import 'package:schedule_app/presentation/screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey =
    GlobalKey<NavigatorState>(debugLabel: 'HomeScreenShell');
final _shellNavigatorBKey =
    GlobalKey<NavigatorState>(debugLabel: 'ScheduleScreenShell');

final groupTeacherRepo = GroupTeacherRepo();

final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: RepositoryProvider.value(
            value: groupTeacherRepo,
            child: BlocProvider(
              create: (context) => GroupTeacherBloc(
                RepositoryProvider.of<GroupTeacherRepo>(context),
              )..add(LoadGroupTeacherBlocEvent()),
              child: const LaunchSplashScreen(),
            ),
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
              name: 'Home',
              path: '/home',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: RepositoryProvider(
                    create: (context) => GroupTeacherRepo(),
                    child: BlocProvider(
                      create: (context) => GroupTeacherBloc(
                        RepositoryProvider.of<GroupTeacherRepo>(context),
                      )..add(LoadGroupTeacherBlocEvent()),
                      child: const HomeScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: '/schedule',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: ScheduleScreen(title: 'Schedule'),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
