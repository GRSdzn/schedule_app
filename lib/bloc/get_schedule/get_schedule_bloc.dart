import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule_app/data/schedule/models/selected_schedule_model.dart';
import 'package:schedule_app/domain/launch_splash/repository/group_teacher_repo_interface.dart';

part 'get_schedule_event.dart';
part 'get_schedule_state.dart';

class GetScheduleBloc extends Bloc<GetScheduleBlocEvent, GetScheduleBlocState> {
  final GetGroupsAndTeachersListInterface repository;

  GetScheduleBloc(this.repository) : super(GetScheduleBlocInitial()) {
    on<GetScheduleEvent>((event, emit) async {
      emit(GetScheduleBlocLoading());

      try {
        final data =
            await repository.getLessonsForGroupTeacher(event.groupName);
        final schedule = ScheduleModel.fromJson(data);
        emit(GetScheduleBlocLoaded(schedule));
      } catch (e) {
        emit(GetScheduleBlocError(e.toString()));
      }
    });
  }
}
