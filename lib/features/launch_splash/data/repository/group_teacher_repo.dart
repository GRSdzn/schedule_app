import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:schedule_app/features/launch_splash/data/models/group_list.dart';
import 'dart:io';
import 'package:schedule_app/features/launch_splash/domain/repository/group_teacher_repo_interface.dart';

class GetGroupsAndTeachersList implements GetGroupsAndTeachersListInterface {
  final String endpoint = 'https://rasp-api.rsue.ru/api/v1/schedule/search/';

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

      print('Success: ${response.statusCode}');

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
