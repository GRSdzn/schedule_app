import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/core/constants/theme/theme.dart';
import 'package:schedule_app/data/launch_splash/repository/group_teacher_repo.dart';
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // GET DATA LIST BLOC
        BlocProvider(
          create: (_) => GetDataListBloc(GetGroupsAndTeachersList()),
        ),
        // THEME SWITCH BLOC
        // BlocProvider(
        //   create: (_) => ThemeBloc(
        //       ThemeBloc()),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Schedule',
        routerConfig: goRouter,
        theme: globalTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
