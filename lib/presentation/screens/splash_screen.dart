// teacher_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import '../../utils/cache_manager.dart';

class LaunchSplashScreen extends StatelessWidget {
  const LaunchSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор преподавателя'),
      ),
      body: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
        builder: (context, state) {
          if (state is GroupTeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GroupTeacherLoaded) {
            return ListView.builder(
              itemCount: state.groupTeachers.length,
              itemBuilder: (context, index) {
                final teacher = state.groupTeachers[index];
                return ListTile(
                    title: Text(teacher.name),
                    onTap: () {
                      // Сохраняем выбранного преподавателя
                      CacheManager.saveSelectedGroupTeacher(
                          teacher.id, teacher.name);
                      context
                          .read<GroupTeacherBloc>()
                          .add(LoadLessonsEvent(teacher));
                      // Возвращаемся на предыдущий экран после выбора
                      GoRouter.of(context).go('/schedule');
                    });
              },
            );
          }
          return const Center(child: Text('Нет доступных преподавателей.'));
        },
      ),
    );
  }
}
