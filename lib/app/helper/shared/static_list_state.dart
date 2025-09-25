import 'package:equatable/equatable.dart';

sealed class StaticListResultState<T> extends Equatable {
  const StaticListResultState();
}

class StaticListResultNone<T> extends StaticListResultState<T> {
  @override
  List<Object> get props => [];
}

class StaticListResultLoading<T> extends StaticListResultState<T> {
  @override
  List<Object> get props => [];
}

class StaticListResultLoaded<T> extends StaticListResultState<T> {
  final List<T> items;

  const StaticListResultLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class StaticListResultError<T> extends StaticListResultState<T> {
  final String message;

  const StaticListResultError(this.message);

  @override
  List<Object> get props => [message];
}
