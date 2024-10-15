part of 'get_data_list_bloc_bloc.dart';

sealed class GetDataListBlocEvent extends Equatable {
  const GetDataListBlocEvent();

  @override
  List<Object> get props => [];
}

// event на получение списка данных
class GetDataListEvent extends GetDataListBlocEvent {}

class GetDataListEventCompleted extends GetDataListBlocEvent {}
