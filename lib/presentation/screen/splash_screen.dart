import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/data/schedule/models/group_list.dart';
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart';
import 'package:schedule_app/presentation/widgets/search_widget.dart';
import 'package:schedule_app/services/preferences_service.dart'; // Импортируйте PreferencesService

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  LaunchSplashScreenState createState() => LaunchSplashScreenState();
}

class LaunchSplashScreenState extends State<LaunchSplashScreen> {
  String searchQuery = ''.toLowerCase();
  final PreferencesService preferencesService =
      PreferencesService(); // Экземпляр PreferencesService

  @override
  void initState() {
    super.initState();
    context.read<GetDataListBloc>().add(LoadDataListEvent());
  }

  List<GroupListData> search(List<GroupListData> groups) {
    return groups
        .where((group) => group.name.toLowerCase().contains(searchQuery))
        .toList();
  }

  Future<void> updateList() async {
    context.read<GetDataListBloc>().add(UpdateDataListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Schedule APP'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: updateList,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SearchWidget(
            searchQuery: searchQuery,
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
      ),
      body: BlocBuilder<GetDataListBloc, GetDataListBlocState>(
        builder: (context, state) {
          if (state is GetDataListBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDataListBlocLoaded) {
            final filteredList = search(state.data);
            return RefreshIndicator(
              onRefresh: updateList,
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final group = filteredList[index];
                  return ListTile(
                    onTap: () async {
                      try {
                        await preferencesService.saveSelectedGroup(group.name);
                        if (kDebugMode) {
                          print('Сохранена группа: ${group.name}');
                        }

                        // Проверяем, что группа сохранилась
                        String? savedGroup =
                            await preferencesService.loadSelectedGroup();
                        if (kDebugMode) {
                          print('Загруженная группа: $savedGroup');
                        }

                        goRouter.push('/schedule');
                      } catch (e) {
                        if (kDebugMode) {
                          print('Ошибка при сохранении группы: $e');
                        }
                      }
                    },
                    title: Text(
                      group.name,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                },
              ),
            );
          } else if (state is GetDataListBlocError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const Center(child: Text('Инициализация...'));
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
