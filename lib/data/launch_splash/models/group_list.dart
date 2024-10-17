class GroupListData {
  final int id; // Change to int as per your API response
  final String name;

  GroupListData({required this.id, required this.name});

  factory GroupListData.fromJson(Map<String, dynamic> json) {
    // Validate JSON keys exist and are of expected types
    if (json['id'] is int && json['name'] is String) {
      return GroupListData(
        id: json['id'],
        name: json['name'],
      );
    } else {
      throw Exception('Invalid JSON structure');
    }
  }
}
