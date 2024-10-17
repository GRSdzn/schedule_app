import 'package:schedule_app/data/schedule/models/group_list.dart';

abstract class GetGroupsAndTeachersListInterface {
  // get all items list
  Future<List<GroupListData>> getGroupTeacher();

  // get selected item info
  Future<Map<String, dynamic>> getLessonsForGroupTeacher(String groupName);
}
