import 'package:schedule_app/data/launch_splash/models/group_list.dart';

abstract class GetGroupsAndTeachersListInterface {
  // get all items list
  Future<List<GroupListData>> getGroupTeacher();
}
