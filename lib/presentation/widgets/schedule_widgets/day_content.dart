import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';
import 'package:schedule_app/core/constants/theme/src/app_rounded.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';

class DayContent extends StatelessWidget {
  final Days day;

  const DayContent({super.key, required this.day});

  String formatTime(String time) {
    final dateTime = DateTime.parse('1970-01-01 $time');
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final pairs = day.pairs
        ?.where((pair) =>
            pair.lessons?.any((lesson) => lesson.subject?.isNotEmpty == true) ==
            true)
        .toList();

    if (pairs == null || pairs.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: appBorderRadiusAll,
      ),
      color: AppColors.primaryLightGray,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.name ?? '',
              style: const TextStyle(fontSize: 24, color: AppColors.textColor),
            ),
            const SizedBox(height: 8.0),
            ...pairs.map((pair) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pair.lessons!
                    .where((lesson) => lesson.subject?.isNotEmpty == true)
                    .map((lesson) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      lesson.subject ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 29, 28, 28),
                      ),
                    ),
                    subtitle: Text(
                      '${formatTime(pair.startTime ?? '')} - ${formatTime(pair.endTime ?? '')}\n${lesson.teacher!.name ?? ''} \n${lesson.audience ?? ''}',
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
