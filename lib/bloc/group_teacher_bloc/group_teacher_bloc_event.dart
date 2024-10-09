part of 'group_teacher_bloc_bloc.dart';

abstract class GroupTeacherBlocEvent extends Equatable {
  const GroupTeacherBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupTeacherBlocEvent extends GroupTeacherBlocEvent {}

class SelectGroupTeacherEvent extends GroupTeacherBlocEvent {
  final GroupTeacherModel selectedTeacher;

  const SelectGroupTeacherEvent(this.selectedTeacher);

  @override
  List<Object?> get props => [selectedTeacher];
}

class LoadLessonsEvent extends GroupTeacherBlocEvent {
  final GroupTeacherModel selectedTeacher;

  const LoadLessonsEvent(this.selectedTeacher);

  @override
  List<Object?> get props => [selectedTeacher];
}
