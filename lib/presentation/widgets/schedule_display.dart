import 'package:flutter/material.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';

class ScheduleDisplay extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleDisplay({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedule.weeks?.length ?? 0,
      itemBuilder: (context, weekIndex) {
        final week = schedule.weeks![weekIndex];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Неделя: ${week.name ?? 'Неделя ${weekIndex + 1}'}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...week.days!.map((day) => _buildDayCard(day)).toList(),
                if (weekIndex < schedule.weeks!.length - 1) const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCard(Days day) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${day.name ?? 'День'} (${day.date})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDayPairs(day),
          ],
        ),
      ),
    );
  }

  Widget _buildDayPairs(Days day) {
    if (day.pairs == null || day.pairs!.isEmpty) {
      return const Text('Нет уроков для этого дня.',
          style: TextStyle(color: Colors.grey));
    }

    return Column(
      children: day.pairs!.map((pair) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 1,
          child: ListTile(
            title:
                Text(pair.lessons!.map((lesson) => lesson.subject).join(', ')),
            subtitle: Text('Время: ${pair.startTime} - ${pair.endTime}'),
          ),
        );
      }).toList(),
    );
  }
}
