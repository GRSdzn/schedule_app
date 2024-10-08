import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.title});

  final String title;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Выравнивание по центру
          children: [
            const Text('Schedule'),
            ElevatedButton(
              onPressed: () {
                // Возврат на главный экран
                GoRouter.of(context).go('/');
              },
              child: const Text('Список'), // Улучшен текст кнопки
            ),
          ],
        ),
      ),
    );
  }
}
