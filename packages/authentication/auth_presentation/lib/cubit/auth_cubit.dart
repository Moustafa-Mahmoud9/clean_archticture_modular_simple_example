import 'package:auth_domain/auth_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'package:core_implementation/core_implementation.dart';
class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(const AuthInitial());

  // Login method
  Future<void> login({
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(const AuthLoginLoading());

    final result = await loginUser(
      LoginBodyEntity(
        phone: phone,
        email: email,
        password:password,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  // Register method
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const AuthRegisterLoading());

    final result = await registerUser(
      RegisterParams(
        email: email,
        password: password,
        name: name,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  // Logout method
  Future<void> logout() async {
    emit(const AuthLogoutLoading());

    final result = await logoutUser(const NoParams());

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final result = await getCurrentUser(const NoParams());

    result.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user)),
    );
  }
}