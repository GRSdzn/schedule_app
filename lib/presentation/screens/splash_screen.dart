import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';

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
      body: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
        builder: (context, state) {
          if (state is GroupTeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GroupTeacherLoaded) {
            return ListView.builder(
              itemCount: state.groupTeachers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.groupTeachers[index].name),
                  onTap: () {
                    // Add any action for when a list item is tapped
                  },
                );
              },
            );
          }
          if (state is GroupTeacherError) {
            return Center(
              child: Text('Error loading group teachers: ${state.message}'),
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
