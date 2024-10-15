import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';

import 'package:schedule_app/features/schedule/domain/schedule_repo_interface.dart';

class ScheduleRepo implements ScheduleRepoInterface {
  final String endpoint = 'https://rasp-api.rsue.ru/api/v1/schedule/search/';

  @override
  Future<Map<String, dynamic>> getLessonsForGroupTeacher(
      String groupName) async {
    final lessonsEndpoint =
        'https://rasp-api.rsue.ru/api/v1/schedule/lessons/$groupName/';
    final client = IOClient(
        HttpClient()..badCertificateCallback = (cert, host, port) => true);

    try {
      final response = await client
          .get(Uri.parse(lessonsEndpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load lessons: ${response.statusCode}');
      }

      final utf8Response = utf8.decode(response.bodyBytes);
      return jsonDecode(utf8Response);
    } catch (e) {
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }
}
