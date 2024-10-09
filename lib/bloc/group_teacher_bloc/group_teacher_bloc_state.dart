part of 'group_teacher_bloc_bloc.dart';

abstract class GroupTeacherBlocState extends Equatable {
  const GroupTeacherBlocState();

  @override
  List<Object?> get props => [];
}

class GroupTeacherLoading extends GroupTeacherBlocState {}

class GroupTeacherLoaded extends GroupTeacherBlocState {
  final List<GroupTeacherModel> groupTeachers;

  const GroupTeacherLoaded(this.groupTeachers);

  @override
  List<Object?> get props => [groupTeachers];
}

class GroupTeacherSelected extends GroupTeacherBlocState {
  final GroupTeacherModel selectedTeacher;

  const GroupTeacherSelected(this.selectedTeacher);

  @override
  List<Object?> get props => [selectedTeacher];
}

class GroupTeacherLessonsLoaded extends GroupTeacherBlocState {
  final ScheduleModel lessons;
  final GroupTeacherModel selectedTeacher;

  const GroupTeacherLessonsLoaded(this.lessons, this.selectedTeacher);

  @override
  List<Object?> get props => [lessons, selectedTeacher];
}

class GroupTeacherError extends GroupTeacherBlocState {
  final String message;

  const GroupTeacherError(this.message);

  @override
  List<Object?> get props => [message];
}
