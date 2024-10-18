part of 'get_data_list_bloc_bloc.dart';

abstract class GetDataListBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// event на получение списка данных
class GetDataListEvent extends GetDataListBlocEvent {}

class GetDataListEventCompleted extends GetDataListBlocEvent {}

class LoadDataListEvent extends GetDataListBlocEvent {}

class UpdateDataListEvent extends GetDataListBlocEvent {}
