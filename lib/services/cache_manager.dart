// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CacheManager {
//   static Future<void> saveSelectedGroupTeacher(int id, String name) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('selected_group_teacher_id', id);
//     await prefs.setString('selected_group_teacher_name', name);
//   }

//   static Future<Map<String, dynamic>?> getSelectedGroupTeacher() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final id = prefs.getInt('selected_group_teacher_id');
//     final name = prefs.getString('selected_group_teacher_name');
//     if (kDebugMode) {
//       print('cached id: $id, name: $name');
//     }
//     if (id != null && name != null) {
//       return {'id': id, 'name': name};
//     }
//     return null;
//   }
// }
