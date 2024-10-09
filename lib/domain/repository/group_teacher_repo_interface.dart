import 'package:schedule_app/data/models/group_teacher_model.dart';

abstract class GroupTeacherRepoInterface {
  Future<List<GroupTeacherModel>> getGroupTeacher();
}
