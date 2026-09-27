import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:yalla_5roga/core/error/failures.dart';
import 'package:yalla_5roga/features/auth/domain/entities/user.dart';
import 'package:yalla_5roga/features/auth/domain/repositories/auth_repository.dart';
import 'package:yalla_5roga/features/auth/domain/usecases/login_usecase.dart';
import 'package:yalla_5roga/features/auth/domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.repository,
  });

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository repository;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> restoreSession() async {
    final result = await repository.getCachedUser();
    result.fold((_) => _user = null, (user) => _user = user);
    notifyListeners();
  }

  Future<bool> login({required String phone, required String password}) {
    return _run(() => loginUseCase(LoginParams(phone: phone, password: password)));
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String password,
  }) {
    return _run(
      () => registerUseCase(
        RegisterParams(name: name, phone: phone, password: password),
      ),
    );
  }

  Future<void> updateProfile({String? phone, String? imageUrl, String? name}) async {
    if (_user == null) return;
    final updated = _user!.copyWith(phone: phone, imageUrl: imageUrl, name: name);
    final result = await repository.saveUser(updated);
    result.fold((failure) => _errorMessage = failure.message, (user) => _user = user);
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.logout();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _run(Future<Either<Failure, User>> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await action();
    return result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}
