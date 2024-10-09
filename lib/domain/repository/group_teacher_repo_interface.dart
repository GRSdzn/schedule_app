import 'package:schedule_app/data/models/group_teacher_model.dart';

abstract class GroupTeacherRepoInterface {
  // get all items list
  Future<List<GroupTeacherModel>> getGroupTeacher();

  // get selected item info
  Future<Map<String, dynamic>> getLessonsForGroupTeacher(String groupName);
}
