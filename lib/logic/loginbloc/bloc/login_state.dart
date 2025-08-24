part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

// Initial State
final class LoginInitial extends LoginState {}

// Login States
final class LogingUser extends LoginState {}

final class LoginUserSuccessfull extends LoginState {
  final String successfullMessage;
  final Map<String, dynamic> data;

  const LoginUserSuccessfull({required this.successfullMessage, required this.data});

  @override
  List<Object> get props => [successfullMessage, data];
}

final class LoginUserFailed extends LoginState {
  final String errorMessage;
  const LoginUserFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Logout States
final class LogingOutUser extends LoginState {}

final class LogingOutUsersuccessfully extends LoginState {
  final String successfullMessage;
  const LogingOutUsersuccessfully({required this.successfullMessage});

  @override
  List<Object> get props => [successfullMessage];
}

final class LogingOutUserFailed extends LoginState {
  final String errorMessage;
  const LogingOutUserFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Registration States
final class RegisteringUser extends LoginState {}

final class RegistrationSuccess extends LoginState {
  final String message;
  final Map<String, dynamic> data;
  const RegistrationSuccess({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

final class RegistrationFailure extends LoginState {
  final String error;
  const RegistrationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Activation States
final class ActivatingAccount extends LoginState {}

final class ActivationSuccess extends LoginState {
  final String message;
  final Map<String, dynamic> data;
  const ActivationSuccess({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

final class ActivationFailure extends LoginState {
  final String error;
  const ActivationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
