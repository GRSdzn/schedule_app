import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/features/launch_splash/data/repository/group_teacher_repo.dart';
import 'package:schedule_app/features/launch_splash/presentation/bloc/get_data_list_bloc_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetDataListBloc(
              GetGroupsAndTeachersList()), // Один экземпляр BLoC
        ),
        // Добавьте сюда другие BLoC, если они у вас есть
      ],
      child: MaterialApp.router(
        title: 'Flutter Schedule',
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
