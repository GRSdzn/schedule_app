
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/data/models/group_teacher_model.dart';
import 'package:go_router/go_router.dart';

// экран с спсиком для выбора группы и преподавателя
class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  State<LaunchSplashScreen> createState() => _LaunchSplashScreenState();
}

class _LaunchSplashScreenState extends State<LaunchSplashScreen> {
  Future<void> selectItem(int index, GroupTeacherModel item) async {
    context.read<GroupTeacherBloc>().add(SelectGroupTeacherEvent(item));

    if (mounted) {
      context.read<GroupTeacherBloc>().add(LoadLessonsEvent(item));
      // Переход на экран расписания
      goRouter.go('/schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups and Teachers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.goNamed('Home'); // Замените на нужный маршрут для Home
              },
              child: const Text('Go to Home'),
            ),
          ),
          Expanded(
            child: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
              builder: (context, state) {
                if (state is GroupTeacherLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GroupTeacherLoaded) {
                  return ListView.builder(
                    itemCount: state.groupTeachers.length,
                    itemBuilder: (context, index) {
                      final groupAndTeacher = state.groupTeachers[index];
                      return ListTile(
                        onTap: () => selectItem(index, groupAndTeacher),
                        title: Text(groupAndTeacher.name),
                      );
                    },
                  );
                }

                if (state is GroupTeacherError) {
                  return Center(
                    child:
                        Text('Error loading group teachers: ${state.message}'),
                  );
                }

                return const Center(child: Text('Unknown state'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
