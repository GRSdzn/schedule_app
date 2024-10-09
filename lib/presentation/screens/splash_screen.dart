import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/utils/cache_manager.dart'; // Импортируйте CacheManager
import 'package:go_router/go_router.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  State<LaunchSplashScreen> createState() => _LaunchSplashScreenState();
}

class _LaunchSplashScreenState extends State<LaunchSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Teachers'),
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
                      final teacher = state.groupTeachers[index];
                      return ListTile(
                        onTap: () async {
                          // Сохраните выбранного преподавателя в BLoC
                          context
                              .read<GroupTeacherBloc>()
                              .add(SelectGroupTeacherEvent(teacher));
                          print('Group teacher tapped: ${teacher.name}');

                          // Вывод сохранённых данных в консоль
                          final selectedItem =
                              await CacheManager.getSelectedGroupTeacher();
                          if (selectedItem != null) {
                            print(
                                'Saved element ID: ${selectedItem['id']}, Name: ${selectedItem['name']}');
                          } else {
                            print('No element selected or saved.');
                          }
                        },
                        title: Text(teacher.name),
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
