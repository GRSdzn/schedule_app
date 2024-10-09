import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Расписание группы ${selectedTeacher?.name ?? ''}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              GoRouter.of(context)
                  .go('/'); // Смена маршрута для выбора преподавателя
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
        builder: (context, state) {
          if (state is GroupTeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupTeacherLessonsLoaded) {
            selectedTeacher = state.selectedTeacher;
            return _buildLessonsList(state.lessons);
          }

          if (state is GroupTeacherError) {
            return Center(
              child: Text('Ошибка загрузки расписания: ${state.message}'),
            );
          }

          if (state is GroupTeacherLoaded) {
            _loadSelectedTeacher(state);
            return _buildGroupTeacherList(state);
          }

          return const Center(child: Text('Неизвестное состояние'));
        },
      ),
    );
  }

  void _loadSelectedTeacher(GroupTeacherLoaded state) async {
    final selectedTeacherData = await CacheManager.getSelectedGroupTeacher();
    if (selectedTeacherData != null) {
      final teacher = state.groupTeachers.firstWhere(
        (teacher) => teacher.name == selectedTeacherData['name'],
      );

      if (teacher != null) {
        setState(() {
          selectedTeacher = teacher; // Устанавливаем выбранного преподавателя
        });
        context.read<GroupTeacherBloc>().add(
            LoadLessonsEvent(teacher)); // Загружаем уроки для нового учителя
      }
    }
  }

  Widget _buildGroupTeacherList(GroupTeacherLoaded state) {
    return Column(
      children: [
        if (state.groupTeachers.isNotEmpty) ...[
          ListTile(
            title: Text(
              'Выбранный преподаватель: ${selectedTeacher?.name ?? "Не выбран"}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                GoRouter.of(context)
                    .go('/'); // Смена маршрута для выбора преподавателя
              },
            ),
          ),
          const Divider(),
        ],
        const SizedBox(height: 20),
        const Expanded(child: Center(child: Text('Загрузка уроков...'))),
      ],
    );
  }

  Widget _buildLessonsList(ScheduleModel lessons) {
    if (lessons.weeks == null || lessons.weeks!.isEmpty) {
      return const Center(child: Text('Нет данных о расписании.'));
    }

    return PageView.builder(
      itemCount: lessons.weeks!.length,
      itemBuilder: (context, weekIndex) {
        final week = lessons.weeks![weekIndex];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Неделя: ${week.id}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...week.days!.map<Widget>((day) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('День: ${day.name}',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    _buildDayPairs(day),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayPairs(Days day) {
    if (day.pairs == null ||
        day.pairs!.isEmpty ||
        day.pairs!
            .every((pair) => pair.lessons == null || pair.lessons!.isEmpty)) {
      return const Text('Нет уроков для этого дня.',
          style: TextStyle(color: Colors.grey));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: day.pairs!.length,
      itemBuilder: (context, pairIndex) {
        final pair = day.pairs![pairIndex];

        // Проверяем наличие названия уроков
        if (pair.lessons != null && pair.lessons!.isNotEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                  pair.lessons!.map((lesson) => lesson.subject).join(', ')),
              subtitle: Text(
                'Время: ${pair.startTime} - ${pair.endTime}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        // Если у урока нет названия, возвращаем SizedBox, чтобы не отображать ничего
        return const SizedBox.shrink();
      },
    );
  }
}
