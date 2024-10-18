import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:schedule_app/data/schedule/models/group_list.dart';
import 'package:schedule_app/domain/launch_splash/repository/group_teacher_repo_interface.dart';

part 'get_data_list_bloc_event.dart';
part 'get_data_list_bloc_state.dart';

class GetDataListBloc extends Bloc<GetDataListBlocEvent, GetDataListBlocState> {
  final GetGroupsAndTeachersListInterface repository;

  GetDataListBloc(this.repository) : super(GetDataListBlocInitial()) {
    // load data
    on<LoadDataListEvent>((event, emit) async {
      if (state is! GetDataListBlocLoaded) {
        // Загружаем данные с сервера если стейт не загружен
        emit(GetDataListBlocLoading());
        try {
          final data = await repository.getGroupTeacher();
          emit(GetDataListBlocLoaded(data));
        } catch (e) {
          emit(GetDataListBlocError(e.toString()));
        }
      }
    });

    // update data
    on<UpdateDataListEvent>((event, emit) async {
      emit(GetDataListBlocLoading());
      try {
        final data = await repository.getGroupTeacher();
        emit(GetDataListBlocLoaded(data));
      } catch (e) {
        emit(GetDataListBlocError(e.toString()));
      }
    });
  }
}
