import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_app/bloc/get_data_list_bloc/get_data_list_bloc_bloc.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';
import 'package:schedule_app/core/constants/theme/src/app_rounded.dart';
import 'package:schedule_app/services/preferences_service.dart';

class MyBottomSheetList extends StatefulWidget {
  MyBottomSheetList(
      {super.key, this.search = true, required this.onGroupSelected});

  bool? search;
  final Function(String) onGroupSelected;
  @override
  State<MyBottomSheetList> createState() => _MyBottomSheetListState();
}

class _MyBottomSheetListState extends State<MyBottomSheetList> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.primaryBackground),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          widget.search != false
              ? TextField(
                  cursorColor: AppColors.primaryGray,
                  style: const TextStyle(
                      color: Colors.white), // Make input text white
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Поиск...',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryLightGray,
                        width: 2.0, // Set a width for the focused underline
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryLightGray,
                        width: 0.0, // Match the width of the focused border
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.red), // Define error state
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.redAccent), // Define focused error state
                    ),
                    suffixIconColor: AppColors.primaryLightGray,
                    prefixIconColor: Colors.blue,
                    filled: true,
                    fillColor: AppColors.primaryLightGray,
                    iconColor: AppColors.primaryGray,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0), // Adjust padding here
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                )
              : const SizedBox(),
          widget.search != false
              ? const SizedBox(height: 16)
              : const SizedBox(),
          Expanded(
            child: BlocBuilder<GetDataListBloc, GetDataListBlocState>(
              builder: (context, state) {
                if (state is GetDataListBlocLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetDataListBlocLoaded) {
                  final filteredList = state.data
                      .where((group) =>
                          group.name.toLowerCase().contains(searchQuery))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final group = filteredList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () async {
                          final preferencesService = PreferencesService();
                          await preferencesService
                              .saveSelectedGroup(group.name);

                          if (mounted) {
                            // Вызываем callback для обновления группы в ScheduleScreen
                            widget.onGroupSelected(group.name);

                            // Закрываем BottomSheet
                            Navigator.of(context).pop();
                          }
                        },
                        title: Text(
                          group.name,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      );
                    },
                  );
                } else if (state is GetDataListBlocError) {
                  return Center(
                      child: Text('Error: ${state.message}',
                          style: const TextStyle(color: Colors.red)));
                }
                return const Center(
                    child: Text('Loading...',
                        style: TextStyle(color: AppColors.primaryGray)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
