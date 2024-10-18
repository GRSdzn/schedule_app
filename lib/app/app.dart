import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/bloc/get_schedule/get_schedule_bloc.dart';
import 'package:schedule_app/core/constants/theme/theme.dart';
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart';
import 'package:schedule_app/data/schedule/repository/schedule_repo.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a single instance of each BLoC
    final getDataListBloc = GetDataListBloc(ScheduleRepo());
    final getScheduleBloc = GetScheduleBloc(ScheduleRepo());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getDataListBloc),
        BlocProvider.value(value: getScheduleBloc),
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
