// group_teacher_bloc_state.dart
part of 'group_teacher_bloc_bloc.dart';

@immutable
abstract class GroupTeacherBlocState extends Equatable {}

// data loading state
class GroupTeacherLoading extends GroupTeacherBlocState {
  @override
  List<Object?> get props => [];
}

// data loaded state
class GroupTeacherLoaded extends GroupTeacherBlocState {
  final List<GroupTeacherModel> groupTeachers;

  GroupTeacherLoaded(this.groupTeachers);

  @override
  List<Object?> get props => [groupTeachers];
}

// data selected state
class GroupTeacherSelected extends GroupTeacherBlocState {
  final GroupTeacherModel selectedTeacher;

  GroupTeacherSelected(this.selectedTeacher);

  @override
  List<Object> get props => [selectedTeacher];
}

// data error state
class GroupTeacherError extends GroupTeacherBlocState {
  final String message;

  GroupTeacherError(this.message);

  @override
  List<Object?> get props => [message];
}

// unknown state
class GroupTeacherLessonsLoaded extends GroupTeacherBlocState {
  final ScheduleModel lessons;

  GroupTeacherLessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}
