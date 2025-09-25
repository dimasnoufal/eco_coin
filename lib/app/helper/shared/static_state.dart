import 'package:equatable/equatable.dart';

sealed class StaticResultState<T> extends Equatable {
  const StaticResultState();
}

class StaticResultNone<T> extends StaticResultState<T> {
  @override
  List<Object?> get props => [];
}

class StaticResultLoading<T> extends StaticResultState<T> {
  @override
  List<Object?> get props => [];
}

class StaticResultLoaded<T> extends StaticResultState<T> {
  final T items;

  const StaticResultLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class StaticResultError<T> extends StaticResultState<T> {
  final String message;

  const StaticResultError(this.message);

  @override
  List<Object?> get props => [message];
}
