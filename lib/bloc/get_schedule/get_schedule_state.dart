part of 'get_schedule_bloc.dart';

sealed class GetScheduleBlocState extends Equatable {
  const GetScheduleBlocState();

  @override
  List<Object> get props => [];
}

final class GetScheduleBlocInitial extends GetScheduleBlocState {}

final class GetScheduleBlocLoading extends GetScheduleBlocState {}

// Обновите этот класс, чтобы принимать данные расписания
final class GetScheduleBlocLoaded extends GetScheduleBlocState {
  final ScheduleModel schedule; // Предполагая, что вы используете ScheduleModel

  const GetScheduleBlocLoaded(this.schedule);

  @override
  List<Object> get props => [schedule];
}

final class GetScheduleBlocError extends GetScheduleBlocState {
  final String message;

  const GetScheduleBlocError(this.message);
}

final class GetScheduleBlocUpdate extends GetScheduleBlocState {}
