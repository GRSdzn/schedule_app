import 'package:schedule_app/data/schedule/models/group_list.dart';

abstract class GetGroupsAndTeachersListInterface {
  // Получение всех групп и преподавателей
  Future<List<GroupListData>> getGroupTeacher();

  // Получение расписания для конкретной группы или преподавателя
  Future<Map<String, dynamic>> getLessonsForGroupTeacher(String groupName);
}
