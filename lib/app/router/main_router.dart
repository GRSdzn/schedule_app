import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/data/repo/group_teacher_repo.dart';
import 'package:schedule_app/presentation/screens/home_screen.dart';

final _key = GlobalKey<NavigatorState>();

final mainRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _key,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return RepositoryProvider(
          create: (context) => GroupTeacherRepo(),
          child: BlocProvider(
            create: (context) => GroupTeacherBloc(
              RepositoryProvider.of<GroupTeacherRepo>(context),
            )..add(LoadGroupTeacherBlocEvent()),
            child: const HomeScreen(),
          ),
        );
      },
    ),
  ],
);
