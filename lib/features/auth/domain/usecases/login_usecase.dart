import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yalla_5roga/core/error/failures.dart';
import 'package:yalla_5roga/core/usecases/usecase.dart';
import 'package:yalla_5roga/features/auth/domain/entities/user.dart';
import 'package:yalla_5roga/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(phone: params.phone, password: params.password);
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.phone, required this.password});

  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}
