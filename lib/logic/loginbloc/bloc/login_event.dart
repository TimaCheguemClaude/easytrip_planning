part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// Login Event
final class LoginUser extends LoginEvent {
  final User user;
  const LoginUser({required this.user});

  @override
  List<Object> get props => [user];
}

// Logout Event
final class LogOut extends LoginEvent {}

// Registration Events
final class RegisterUser extends LoginEvent {
  final Character character;
  const RegisterUser({required this.character});

  @override
  List<Object> get props => [character];
}

// Activation Events
final class ActivateAccount extends LoginEvent {
  final int userId;
  final String activationCode;
  
  const ActivateAccount({
    required this.userId,
    required this.activationCode,
  });

  @override
  List<Object> get props => [userId, activationCode];
}
