abstract class ScheduleRepoInterface {
  // get selected item info
  Future<Map<String, dynamic>> getLessonsForGroupTeacher(String groupName);
}
