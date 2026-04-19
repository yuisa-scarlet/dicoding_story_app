import 'package:equatable/equatable.dart';

sealed class BaseResultState<T> extends Equatable {
  const BaseResultState();

  @override
  List<Object?> get props => [];
}

class BaseResultStateInitial<T> extends BaseResultState<T> {
  const BaseResultStateInitial();
}

class BaseResultStateLoading<T> extends BaseResultState<T> {
  const BaseResultStateLoading();
}

class BaseResultStateSuccess<T> extends BaseResultState<T> {
  final T data;

  const BaseResultStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class BaseResultStateError<T> extends BaseResultState<T> {
  final String errorMessage;

  const BaseResultStateError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
