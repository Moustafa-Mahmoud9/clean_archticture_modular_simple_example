import 'package:auth_domain/auth_domain.dart';
import 'package:core/core_package.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Authenticated state (user is logged in)
class AuthAuthenticated extends AuthState {
  final LoginResponseEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Unauthenticated state (user is logged out)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Login loading state
class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

// Register loading state
class AuthRegisterLoading extends AuthState {
  const AuthRegisterLoading();
}

// Logout loading state
class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();
}