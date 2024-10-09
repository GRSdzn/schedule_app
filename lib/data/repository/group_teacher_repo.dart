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
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    Client client = IOClient(httpClient);

    try {
      Response response = await client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonResponse = jsonDecode(utf8Response);

        return jsonResponse.map((e) {
          if (e is Map<String, dynamic>) {
            return GroupTeacherModel.fromJson(e);
          } else {
            throw Exception('Expected JSON object but got: $e');
          }
        }).toList();
      } else {
        print(
            'Request failed with status: ${response.statusCode} and body: ${response.body}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> getLessonsForGroupTeacher(
      String groupName) async {
    final String lessonsEndpoint =
        'https://rasp-api.rsue.ru/api/v1/schedule/lessons/$groupName/';

    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    final Client client = IOClient(httpClient);
    print("groupName $groupName");
    try {
      Response response = await client
          .get(Uri.parse(lessonsEndpoint))
          .timeout(const Duration(seconds: 10));

      // Логирование кода состояния
      print('Lessons request status code: ${response.statusCode}');

      // Логирование содержимого ответа
      print('Lessons request body: ${response.body}');
      print("groupName $groupName");

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8Response);
        return jsonResponse; // Возвращаем данные о занятиях
      } else {
        print(
            'Error: Failed to load lessons with status code: ${response.statusCode} and body: ${response.body}');
        throw Exception('Failed to load lessons: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }
}
