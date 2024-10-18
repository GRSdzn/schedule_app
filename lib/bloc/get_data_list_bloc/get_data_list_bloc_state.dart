part of 'get_data_list_bloc_bloc.dart';

sealed class GetDataListBlocState extends Equatable {
  const GetDataListBlocState();

  @override
  List<Object> get props => [];
}

final class GetDataListBlocInitial extends GetDataListBlocState {}

final class GetDataListBlocLoading extends GetDataListBlocState {}

class GetDataListBlocLoaded extends GetDataListBlocState {
  final List<GroupListData> data;

  const GetDataListBlocLoaded(this.data);
}

final class GetDataListBlocError extends GetDataListBlocState {
  final String message;
  const GetDataListBlocError(this.message);
}

final class GetDataListBlocUpdate extends GetDataListBlocState {}
