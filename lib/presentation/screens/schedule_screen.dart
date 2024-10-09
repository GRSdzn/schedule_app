import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/group_teacher_bloc/group_teacher_bloc_bloc.dart';
import 'package:schedule_app/data/models/group_teacher_model.dart';
import 'package:schedule_app/data/models/schedule_model.dart';

import '../../utils/cache_manager.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  GroupTeacherModel? selectedTeacher;

  @override
  void initState() {
    super.initState();
    _loadSelectedTeacher();
  }

  void _loadSelectedTeacher() async {
    final selectedTeacherData = await CacheManager.getSelectedGroupTeacher();
    if (selectedTeacherData != null) {
      // Загрузка преподавателя из кэша, если он есть
      // Обрабатываем состояния
      final currentState = context.read<GroupTeacherBloc>().state;
      if (currentState is GroupTeacherLoaded) {
        final teacher = currentState.groupTeachers.firstWhere(
          (teacher) => teacher.id == selectedTeacherData['id'],
        );
        if (teacher != null) {
          selectedTeacher = teacher;
          context.read<GroupTeacherBloc>().add(LoadLessonsEvent(teacher));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Расписание"),
      ),
      body: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
        builder: (context, state) {
          if (state is GroupTeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GroupTeacherLessonsLoaded) {
            return _buildLessonsList(state.lessons);
          }
          if (state is GroupTeacherError) {
            return Center(
              child: Text('Ошибка загрузки расписания: ${state.message}'),
            );
          }
          if (state is GroupTeacherLoaded) {
            if (state.groupTeachers.isNotEmpty) {
              return Column(
                children: [
                  DropdownButton<GroupTeacherModel>(
                    value: selectedTeacher,
                    hint: const Text('Выберите преподавателя'),
                    items: state.groupTeachers.map((teacher) {
                      return DropdownMenuItem<GroupTeacherModel>(
                        value: teacher,
                        child: Text(teacher.name),
                      );
                    }).toList(),
                    onChanged: (teacher) {
                      setState(() {
                        selectedTeacher = teacher;
                      });
                      context
                          .read<GroupTeacherBloc>()
                          .add(LoadLessonsEvent(teacher!));
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
            return const Center(child: Text('Нет доступных преподавателей.'));
          }

          print('Unknown state: $state');
          return const Center(child: Text('Неизвестное состояние'));
        },
      ),
    );
  }

  Widget _buildLessonsList(ScheduleModel lessons) {
    if (lessons.weeks == null || lessons.weeks!.isEmpty) {
      return const Center(child: Text('Нет доступных уроков.'));
    }
    return ListView.builder(
      itemCount: lessons.weeks!.length,
      itemBuilder: (context, weekIndex) {
        final week = lessons.weeks![weekIndex];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Неделя: ${week.name}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...week.days!.map<Widget>((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('День: ${day.name}',
                          style: const TextStyle(fontSize: 16)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: day.pairs!.length,
                        itemBuilder: (context, pairIndex) {
                          final pair = day.pairs![pairIndex];
                          if (pair.lessons == null || pair.lessons!.isEmpty) {
                            return const ListTile(
                                title: Text('Нет доступных уроков'));
                          }
                          return Column(
                            children: pair.lessons!.map<Widget>((lesson) {
                              return ListTile(
                                title: Text(lesson.subject ?? 'Нет названия'),
                                subtitle: Text(
                                  'Время: ${pair.startTime} - ${pair.endTime}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
