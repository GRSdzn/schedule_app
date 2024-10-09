import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:schedule_app/data/models/group_teacher_model.dart';
import 'package:schedule_app/domain/repository/group_teacher_repo_interface.dart';

class GroupTeacherRepo implements GroupTeacherRepoInterface {
  final String endpoint = 'https://rasp-api.rsue.ru/api/v1/schedule/search/';

  @override
  Future<List<GroupTeacherModel>> getGroupTeacher() async {
    final client = IOClient(
        HttpClient()..badCertificateCallback = (cert, host, port) => true);

    try {
      final response = await client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      final utf8Response = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonResponse = jsonDecode(utf8Response);

      return jsonResponse.map((e) => GroupTeacherModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }

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
