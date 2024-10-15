part of 'get_data_list_bloc_bloc.dart';

sealed class GetDataListBlocState extends Equatable {
  const GetDataListBlocState();

  @override
  List<Object> get props => [];
}

final class GetDataListBlocInitial extends GetDataListBlocState {}

final class GetDataListBlocLoading extends GetDataListBlocState {}

final class GetDataListBlocLoaded extends GetDataListBlocState {
  // список всех групп и преподавателей
  final List<GroupListData> groupsAndTeacherList;
  const GetDataListBlocLoaded(this.groupsAndTeacherList);

  @override
  List<Object> get props => [groupsAndTeacherList];
}

final class GetDataListBlocError extends GetDataListBlocState {
  final String message;
  const GetDataListBlocError(this.message);
}

final class GetDataListBlocUpdate extends GetDataListBlocState {}
