import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Импортируем для работы с Bloc
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart'; // Импортируйте ваш BLoC
import 'package:schedule_app/services/preferences_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? selectedGroupName;
  final PreferencesService preferencesService = PreferencesService();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedGroup();
  }

  Future<void> _loadSelectedGroup() async {
    selectedGroupName = await preferencesService.loadSelectedGroup();
    setState(() {});
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
                            print('Сохранена группа: ${group.name}'); // Отладка
                            setState(() {
                              selectedGroupName =
                                  group.name; // Обновляем состояние
                            });
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
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showBottomSheet(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Вы выбрали группу: ${selectedGroupName ?? "Не выбрано"}'),
      ),
    );
  }
}
