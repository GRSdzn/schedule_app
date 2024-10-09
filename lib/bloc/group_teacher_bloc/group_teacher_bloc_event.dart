// group_teacher_bloc_event.dart
part of 'group_teacher_bloc_bloc.dart';

@immutable
abstract class GroupTeacherBlocEvent extends Equatable {
  const GroupTeacherBlocEvent();
}

class LoadGroupTeacherBlocEvent extends GroupTeacherBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectGroupTeacherEvent extends GroupTeacherBlocEvent {
  final GroupTeacherModel selectedTeacher;

  const SelectGroupTeacherEvent(this.selectedTeacher);

  @override
  List<Object> get props => [selectedTeacher];
}

class LoadLessonsEvent extends GroupTeacherBlocEvent {
  final GroupTeacherModel selectedTeacher;

  const LoadLessonsEvent(this.selectedTeacher);

  @override
  List<Object> get props => [selectedTeacher];
}
