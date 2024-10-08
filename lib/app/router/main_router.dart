import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/app/router/scaffold_with_nested_navigation.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/data/repo/group_teacher_repo.dart';
import 'package:schedule_app/presentation/screens/home_screen.dart';
import 'package:schedule_app/presentation/screens/shedule_screen.dart'; // Fixed import path

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey =
    GlobalKey<NavigatorState>(debugLabel: 'HomeScreenShell');
final _shellNavigatorBKey =
    GlobalKey<NavigatorState>(debugLabel: 'ScheduleScreenShell');

// The one and only GoRouter instance
final goRouter = GoRouter(
  initialLocation: '/', // Set this to your preferred initial route
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        // First branch (A)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
              path: '/',
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
        // Second branch (B)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
              path: '/schedule',
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: ScheduleScreen(
                      title: 'Schedule'), // Updated screen instantiation
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
