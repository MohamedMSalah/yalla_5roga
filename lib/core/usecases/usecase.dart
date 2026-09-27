import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yalla_5roga/core/error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
