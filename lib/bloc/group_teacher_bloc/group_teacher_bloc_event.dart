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
