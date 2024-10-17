part of 'get_schedule_bloc.dart';

sealed class GetScheduleBlocEvent extends Equatable {
  const GetScheduleBlocEvent();

  @override
  List<Object> get props => [];
}

// Событие для получения расписания для конкретной группы
class GetScheduleEvent extends GetScheduleBlocEvent {
  final String groupName;

  const GetScheduleEvent(this.groupName);

  @override
  List<Object> get props => [groupName];
}

// Другие события...
class GetScheduleEventCompleted extends GetScheduleBlocEvent {}
