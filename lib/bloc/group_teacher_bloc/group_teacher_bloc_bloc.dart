import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:schedule_app/data/models/group_teacher_model.dart';
import 'package:schedule_app/utils/cache_manager.dart'; // Импортируйте CacheManager
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

    on<SelectGroupTeacherEvent>((event, emit) {
      emit(GroupTeacherSelected(event.selectedTeacher));

      // Сохраните выбранного преподавателя в кэше
      CacheManager.saveSelectedGroupTeacher(
          event.selectedTeacher.id, event.selectedTeacher.name);
    });
  }
}
