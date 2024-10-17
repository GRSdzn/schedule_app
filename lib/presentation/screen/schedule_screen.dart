import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart';
import 'package:schedule_app/bloc/get_schedule/get_schedule_bloc.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';
import 'package:schedule_app/presentation/widgets/custom_app_bar.dart';
import 'package:schedule_app/services/preferences_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? selectedGroupName;
  final PreferencesService preferencesService = PreferencesService();
  late PageController _pageController;
  ScheduleModel? currentSchedule;
  String searchQuery = '';
  int currentPageIndex = 0; // Current page index tracking

  @override
  void initState() {
    super.initState();
    _loadSelectedGroup();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPageIndex = _pageController.page!.round();
        });
      });
  }

  Future<void> _loadSelectedGroup() async {
    selectedGroupName = await preferencesService.loadSelectedGroup();
    setState(() {});

    if (selectedGroupName != null && mounted) {
      BlocProvider.of<GetScheduleBloc>(context)
          .add(GetScheduleEvent(selectedGroupName!));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return BlocBuilder<GetDataListBloc, GetDataListBlocState>(
          builder: (context, state) {
            if (state is GetDataListBlocLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetDataListBlocLoaded) {
              final filteredGroups = state.groupsAndTeacherList.where((group) {
                return group.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Поиск',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredGroups.length,
                      itemBuilder: (context, index) {
                        final group = filteredGroups[index];
                        return ListTile(
                          title: Text(group.name),
                          onTap: () async {
                            await preferencesService
                                .saveSelectedGroup(group.name);
                            setState(() {
                              selectedGroupName = group.name; // Update state
                            });
                            // Load schedule for the selected group
                            BlocProvider.of<GetScheduleBloc>(context)
                                .add(GetScheduleEvent(group.name));
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is GetDataListBlocError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }

            return const Center(child: Text('Инициализация...'));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: selectedGroupName ?? 'Выберите группу',
        onTitleTap: () => _showBottomSheet(context),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<GetScheduleBloc, GetScheduleBlocState>(
        builder: (context, state) {
          if (state is GetScheduleBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetScheduleBlocLoaded) {
            currentSchedule = state.schedule; // Получение расписания
            return _buildSchedulePageView(currentSchedule!);
          } else if (state is GetScheduleBlocError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const Center(child: Text('пусто...'));
        },
      ),
    );
  }

  Widget _buildSchedulePageView(ScheduleModel schedule) {
    return PageView.builder(
      controller: _pageController,
      itemCount: schedule.weeks?.length ?? 0,
      itemBuilder: (context, index) {
        final week = schedule.weeks![index];
        return _buildWeekContent(week);
      },
      onPageChanged: (index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }

  Widget _buildWeekContent(Weeks week) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.primaryBackground,
          pinned: false,
          floating: false,
          snap: false,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Неделя: ${week.name}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Дата: ${week.days?.isNotEmpty == true ? week.days![0].date : 'Нет данных'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)), // Закругленные края сверху
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // тень снизу
                ),
              ],
            ),
            margin: const EdgeInsets.only(top: 10.0), // Отступ сверху
            child: Column(
              children:
                  week.days?.map((day) => _buildDayContent(day)).toList() ?? [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayContent(Days day) {
    final pairs = day.pairs
        ?.where((pair) =>
            pair.lessons?.any((lesson) => lesson.subject?.isNotEmpty == true) ==
            true)
        .toList();

    if (pairs == null || pairs.isEmpty) {
      return const SizedBox(); // Don't display day if no pairs
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shadowColor: Colors.transparent,
      color: AppColors.primaryLightGray,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${day.name}',
                  style:
                      const TextStyle(fontSize: 24, color: AppColors.textColor),
                ),
                Text(
                  '${day.date}',
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(166, 96, 125, 139)),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              children: pairs.map((pair) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pair.lessons!
                      .where((lesson) => lesson.subject?.isNotEmpty == true)
                      .map((lesson) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(lesson.subject ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                      subtitle: Text('${pair.startTime} - ${pair.endTime}'),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
