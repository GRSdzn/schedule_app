import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/features/launch_splash/data/models/group_list.dart';
import 'package:schedule_app/features/launch_splash/presentation/bloc/get_data_list_bloc_bloc.dart';

class LaunchSplashScreen extends StatefulWidget {
  const LaunchSplashScreen({super.key});

  @override
  LaunchSplashScreenState createState() => LaunchSplashScreenState();
}

class LaunchSplashScreenState extends State<LaunchSplashScreen> {
  String searchQuery = ''.toLowerCase();
  Timer? debounce; // Переменная для таймера

  @override
  void initState() {
    super.initState();
    // Запускаем событие для получения данных
    BlocProvider.of<GetDataListBloc>(context).add(GetDataListEvent());
  }

  // Функция поиска
  List<GroupListData> search(List<GroupListData> groups) {
    return groups
        .where((group) =>
            group.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule APP'),
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
                    searchQuery = value;
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
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final group = filteredList[index];
                return ListTile(
                  onTap: () =>
                      // ignore: avoid_print
                      print('u clicked on ${group.name} with ${group.id}'),
                  title: Text(group.name),
                );
              },
            );
          } else if (state is GetDataListBlocError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ошибка: ${state.message}'),
                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => {
                          BlocProvider.of<GetDataListBloc>(context)
                              .add(GetDataListEvent())
                        },
                    child: const Text('Retry')),
              ],
            ));
          }
          return const Center(child: Text('Инициализация...'));
        },
      ),
    );
  }
}
