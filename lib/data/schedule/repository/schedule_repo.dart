import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'package:schedule_app/data/schedule/models/group_list.dart';
import 'dart:io';

import 'package:schedule_app/domain/launch_splash/repository/group_teacher_repo_interface.dart';

class ScheduleRepo implements GetGroupsAndTeachersListInterface {
  final String endpoint = 'https://rasp-api.rsue.ru/api/v1/schedule/search/';

  // получение расписания конкретного элемента списка
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

      // print(utf8Response);
      if (kDebugMode) {
        print('данные получены успешно');
      }
      return jsonDecode(utf8Response);
    } catch (e) {
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }

  // получение списка
  @override
  Future<List<GroupListData>> getGroupTeacher() async {
    final client = IOClient(
      HttpClient()..badCertificateCallback = (cert, host, port) => true,
    );

    try {
      final response = await client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      if (kDebugMode) {
        print('Success: ${response.statusCode}');
      }

      final utf8Response = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(utf8Response);

      return jsonResponse.map((e) => GroupListData.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }
}
