import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class OffLineFailure extends Failure {
  const OffLineFailure([String message = 'No internet connection']) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure([String message = 'No cached data available']) : super(message);
}