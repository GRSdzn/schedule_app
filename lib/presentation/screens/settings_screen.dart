import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Выравнивание по центру
          children: [
            const Text('Settings'),
            ElevatedButton(
              onPressed: () {
                // Возврат на главный экран
                GoRouter.of(context).go('/select-item');
              },
              child: const Text('Список'), // Улучшен текст кнопки
            ),
          ],
        ),
      ),
    );
  }
}
