import 'package:schedule_app/features/launch_splash/data/models/group_list.dart';

abstract class GetGroupsAndTeachersListInterface {
  // get all items list
  Future<List<GroupListData>> getGroupTeacher();
}
