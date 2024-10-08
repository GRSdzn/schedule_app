import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:schedule_app/data/models/group_teacher_model.dart';

class GroupTeacherRepo {
  String endpoint = 'https://rasp-api.rsue.ru/api/v1/schedule/search/';

  Future<List<GroupTeacherModel>> getGroupTeacher() async {
    // Bypass certificate verification (Development only)
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // игнорировать SSL-сертификат

    Client client = IOClient(httpClient);

    try {
      Response response = await client.get(Uri.parse(endpoint)).timeout(
          const Duration(
              seconds: 10)); //  timeout для ограничения времени ожидания ответа

      if (response.statusCode == 200) {
        // Декодировать тело ответа как UTF-8
        final utf8Response =
            utf8.decode(response.bodyBytes); // Используйте bodyBytes
        final List<dynamic> jsonResponse = jsonDecode(utf8Response);

        // Map each item to GroupTeacherModel
        return jsonResponse.map((e) {
          if (e is Map<String, dynamic>) {
            return GroupTeacherModel.fromJson(e);
          } else {
            throw Exception('Expected JSON object but got: $e');
          }
        }).toList();
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Network error: $e');
      }
      throw Exception('Network error: $e');
    } finally {
      client.close();
    }
  }
}
