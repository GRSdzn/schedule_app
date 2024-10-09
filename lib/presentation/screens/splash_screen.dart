import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:go_router/go_router.dart'; // Импортируйте GoRouter для навигации

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
          // Кнопка для перехода на экран Home
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
                      return ListTile(
                        onTap: () => print(
                            'Group teacher tapped: ${state.groupTeachers[index].name}'),
                        title: Text(state.groupTeachers[index].name),
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
