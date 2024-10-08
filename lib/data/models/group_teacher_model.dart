class GroupTeacherModel {
  final int id; // Change to int as per your API response
  final String name;

  GroupTeacherModel({required this.id, required this.name});

  factory GroupTeacherModel.fromJson(Map<String, dynamic> json) {
    // Validate JSON keys exist and are of expected types
    if (json['id'] is int && json['name'] is String) {
      return GroupTeacherModel(
        id: json['id'],
        name: json['name'],
      );
    } else {
      throw Exception('Invalid JSON structure');
    }
  }
}
