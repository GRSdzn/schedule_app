import 'package:flutter/foundation.dart';
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
    _loadSelectedTeacher();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(selectedTeacher?.name);
    }
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<GroupTeacherBloc, GroupTeacherBlocState>(
          builder: (context, state) {
            if (state is GroupTeacherLessonsLoaded) {
              return Text("Расписание ${state.selectedTeacher.name}");
            }
            // reutnr null if state is loading
            return const SizedBox.shrink();
          },
        ),
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
          return Stack(
            children: [
              _buildMainContent(state),
              if (state is GroupTeacherLoading)
                const Center(
                    child: CircularProgressIndicator()), // Индикатор загрузки
            ],
          );
        },
      ),
    );
  }

  void _loadSelectedTeacher() async {
    final selectedTeacherData = await CacheManager.getSelectedGroupTeacher();
    if (selectedTeacherData != null) {
      if (mounted) {
        final bloc = context.read<GroupTeacherBloc>();
        bloc.add(
            LoadGroupTeacherBlocEvent()); // Запрос на загрузку преподавателей

        // Используем listen для определения состояния, чтобы загрузить уроки в случае успеха
        bloc.stream.listen((state) {
          if (state is GroupTeacherLoaded) {
            selectedTeacher = state.groupTeachers.firstWhere(
              (teacher) => teacher.name == selectedTeacherData['name'],
              orElse: null,
            );

            if (selectedTeacher != null) {
              bloc.add(LoadLessonsEvent(
                  selectedTeacher!)); // Запрос на загрузку уроков
            }
          }
        });
      }
    }
  }

  Widget _buildMainContent(GroupTeacherBlocState state) {
    if (state is GroupTeacherLessonsLoaded) {
      return _buildLessonsList(state.lessons);
    }
    if (state is GroupTeacherError) {
      return Center(
          child: Text('Ошибка загрузки расписания: ${state.message}'));
    }
    if (state is GroupTeacherLoading || state is GroupTeacherLoaded) {
      return const Center(
          child: Text('Загрузка расписания. Пожалуйста, подождите.'));
    }

    return const Center(child: Text('Неизвестное состояние'));
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
              Text('Неделя: ${week.id}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
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
        return const SizedBox.shrink();
      },
    );
  }
}
