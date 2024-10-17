class ScheduleModel {
  String? kind;
  String? instance;
  List<Weeks>? weeks;

  ScheduleModel({this.kind, this.instance, this.weeks});

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : kind = json['kind'],
        instance = json['instance'],
        weeks = (json['weeks'] as List<dynamic>?)
            ?.map((e) => Weeks.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'instance': instance,
      'weeks': weeks?.map((e) => e.toJson()).toList(),
    };
  }
}

class Weeks {
  int? id;
  String? name;
  bool? current;
  int? parity;
  List<Days>? days;

  Weeks({this.id, this.name, this.current, this.parity, this.days});

  Weeks.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        current = json['current'],
        parity = json['parity'],
        days = (json['days'] as List<dynamic>?)
            ?.map((e) => Days.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'current': current,
      'parity': parity,
      'days': days?.map((e) => e.toJson()).toList(),
    };
  }
}

class Days {
  int? id;
  String? date;
  String? name;
  List<Pairs>? pairs;

  Days({this.id, this.date, this.name, this.pairs});

  Days.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        name = json['name'],
        pairs = (json['pairs'] as List<dynamic>?)
            ?.map((e) => Pairs.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'name': name,
      'pairs': pairs?.map((e) => e.toJson()).toList(),
    };
  }
}

class Pairs {
  int? id;
  String? startTime;
  String? endTime;
  List<Lessons>? lessons;

  Pairs({this.id, this.startTime, this.endTime, this.lessons});

  Pairs.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        lessons = (json['lessons'] as List<dynamic>?)
            ?.map((e) => Lessons.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'lessons': lessons?.map((e) => e.toJson()).toList(),
    };
  }
}

class Lessons {
  int? id;
  Teacher? teacher;
  Teacher? subgroup;
  String? subject;
  String? group;
  Kind? kind;
  String? audience;

  Lessons(
      {this.id,
      this.teacher,
      this.subgroup,
      this.subject,
      this.group,
      this.kind,
      this.audience});

  Lessons.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        teacher =
            json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
        subgroup = json['subgroup'] != null
            ? Teacher.fromJson(json['subgroup'])
            : null,
        subject = json['subject'],
        group = json['group'],
        kind = json['kind'] != null ? Kind.fromJson(json['kind']) : null,
        audience = json['audience'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher': teacher?.toJson(),
      'subgroup': subgroup?.toJson(),
      'subject': subject,
      'group': group,
      'kind': kind?.toJson(),
      'audience': audience,
    };
  }
}

class Teacher {
  int? id;
  String? name;

  Teacher({this.id, this.name});

  Teacher.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Kind {
  int? id;
  String? name;
  String? shortName;

  Kind({this.id, this.name, this.shortName});

  Kind.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        shortName = json['shortName'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
    };
  }
}
