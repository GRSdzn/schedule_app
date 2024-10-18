import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/get_schedule/get_schedule_bloc.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';
import 'package:schedule_app/core/constants/theme/src/app_rounded.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';
import 'package:schedule_app/presentation/widgets/bottom_sheet_data.dart';
import 'package:schedule_app/presentation/widgets/custom_app_bar.dart';
import 'package:schedule_app/presentation/widgets/schedule_widgets/week_content.dart';
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
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPageIndex = _pageController.page!.round();
        });
      });
    _loadSelectedGroup();
  }

  Future<void> _loadSelectedGroup() async {
    selectedGroupName = await preferencesService.loadSelectedGroup();
    setState(
        () {}); // Обновить состояние, чтобы перерисовать виджет с новым значением
    if (selectedGroupName != null) {
      _loadSchedule();
    }
  }

  void _loadSchedule() {
    final state = BlocProvider.of<GetScheduleBloc>(context).state;
    if (state is! GetScheduleBlocLoaded ||
        state.schedule.groupName != selectedGroupName) {
      BlocProvider.of<GetScheduleBloc>(context)
          .add(GetScheduleEvent(selectedGroupName!));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryBackground,
      isScrollControlled: false,
      showDragHandle: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(borderRadius: appBorderRadiusTop),
      context: context,
      builder: (context) {
        return MyBottomSheetList(
          onGroupSelected: (selectedGroup) {
            setState(() {
              selectedGroupName = selectedGroup;
            });
            _loadSchedule();
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
            currentSchedule = state.schedule;
            return _buildSchedulePageView(currentSchedule!);
          } else if (state is GetScheduleBlocError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.primaryColor),
                    ),
                    onPressed: () => _showBottomSheet(context),
                    child: const Text('Список'),
                  ),
                ],
              ),
            );
          }
          return const Center(
              child: Text('пусто...', style: TextStyle(color: Colors.red)));
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
        return WeekContent(week: week);
      },
      onPageChanged: (index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
