import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yalla_5roga/core/error/failures.dart';
import 'package:yalla_5roga/core/usecases/usecase.dart';
import 'package:yalla_5roga/features/auth/domain/entities/user.dart';
import 'package:yalla_5roga/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      phone: params.phone,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
  });

  final String name;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [name, phone, password];
}
