import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import '../../utils/cache_manager.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  LaunchSplashScreenState createState() => LaunchSplashScreenState();
}

class LaunchSplashScreenState extends State<LaunchSplashScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор преподавателя'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Обновляем поисковый запрос
                });
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
        builder: (context, state) {
          if (state is GroupTeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GroupTeacherLoaded) {
            // Фильтруем список преподавателей по введенному тексту
            final filteredTeachers = state.groupTeachers.where((teacher) {
              return teacher.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            return ListView.builder(
              itemCount: filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = filteredTeachers[index];
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
                  },
                );
              },
            );
          }
          return const Center(
              child: Text('Нет доступных групп и преподавателей.'));
        },
      ),
    );
  }
}
