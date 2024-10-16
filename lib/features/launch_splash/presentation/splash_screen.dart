import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/app/router/main_router.dart';
import 'package:schedule_app/features/launch_splash/data/models/group_list.dart';
import 'package:schedule_app/features/launch_splash/presentation/bloc/get_data_list_bloc_bloc.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  LaunchSplashScreenState createState() => LaunchSplashScreenState();
}

class LaunchSplashScreenState extends State<LaunchSplashScreen> {
  String searchQuery = ''.toLowerCase();
  Timer? debounce; // Таймер для поиска

  @override
  void initState() {
    super.initState();
    // Запускаем событие для получения данных
    BlocProvider.of<GetDataListBloc>(context).add(GetDataListEvent());
  }

  // Функция поиска
  List<GroupListData> search(List<GroupListData> groups) {
    return groups
        .where((group) => group.name.toLowerCase().contains(searchQuery))
        .toList();
  }

  // Метод обновления данных
  Future<void> updateList() async {
    BlocProvider.of<GetDataListBloc>(context).add(GetDataListEvent());
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
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (debounce?.isActive ?? false) debounce!.cancel();
                debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                });
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<GetDataListBloc, GetDataListBlocState>(
        builder: (context, state) {
          if (state is GetDataListBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDataListBlocLoaded) {
            // Отображение списка загруженных данных
            final filteredList = search(state.groupsAndTeacherList);
            return RefreshIndicator(
              onRefresh: updateList, // Метод обновления при потягивании вниз
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final group = filteredList[index];
                  return ListTile(
                    onTap: () => {
                      // ignore: avoid_print
                      print('Вы кликнули на ${group.name} с ID ${group.id}'),
                      goRouter.push('/schedule'),
                    },
                    title: Text(group.name),
                  );
                },
              ),
            );
          } else if (state is GetDataListBlocError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: updateList,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Инициализация...'));
        },
      ),
    );
  }

  @override
  void dispose() {
    debounce?.cancel(); // Отменяем таймер, если он активен
    super.dispose();
  }
}
