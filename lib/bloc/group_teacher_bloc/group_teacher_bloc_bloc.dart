import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule_app/data/models/group_teacher_model.dart';
import 'package:schedule_app/data/models/schedule_model.dart';
import 'package:schedule_app/utils/cache_manager.dart';
import 'package:schedule_app/domain/repository/group_teacher_repo_interface.dart';

part 'group_teacher_bloc_event.dart';
part 'group_teacher_bloc_state.dart';

class GroupTeacherBloc
    extends Bloc<GroupTeacherBlocEvent, GroupTeacherBlocState> {
  final GroupTeacherRepoInterface _groupTeacherRepository;

  GroupTeacherBloc(this._groupTeacherRepository)
      : super(GroupTeacherLoading()) {
    on<LoadGroupTeacherBlocEvent>((event, emit) async {
      emit(GroupTeacherLoading());
      try {
        final groupTeachers = await _groupTeacherRepository.getGroupTeacher();
        emit(GroupTeacherLoaded(groupTeachers));
      } catch (e) {
        emit(GroupTeacherError(e.toString()));
      }
    });

    on<SelectGroupTeacherEvent>((event, emit) async {
      emit(GroupTeacherSelected(event.selectedTeacher));
      await CacheManager.saveSelectedGroupTeacher(
          event.selectedTeacher.id, event.selectedTeacher.name);
    });

    on<LoadLessonsEvent>((event, emit) async {
      emit(GroupTeacherLoading());
      try {
        final selectedTeacherName = event.selectedTeacher.name;
        final lessonsData = await _groupTeacherRepository
            .getLessonsForGroupTeacher(selectedTeacherName);
        final scheduleModel = ScheduleModel.fromJson(lessonsData);

        emit(GroupTeacherLessonsLoaded(scheduleModel,
            event.selectedTeacher)); // передаем выбранного преподавателя
      } catch (e) {
        emit(GroupTeacherError(e.toString()));
      }
    });
  }
}
