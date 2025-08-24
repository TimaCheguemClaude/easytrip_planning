//import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:easytrip/data/model/mainuser.dart';
import 'package:easytrip/data/model/user.dart';
import 'package:easytrip/data/provider/repository/loginrepository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    // Login User
    on<LoginUser>((event, emit) async {
      emit(LogingUser());
      try {
        final response = await loginRepository.loginUser(event.user);

        // Always check success flag first
        if (response['success'] == true) {
          // Check if we have user data
          if (response['data'] != null && response['data']['user'] != null) {
            final userData = response['data']['user'];

            // Check activation status
            if (userData['activated'] == 0) {
              // Account exists but is not activated
              emit(
                LoginUserSuccessfull(
                  successfullMessage: 'Account requires activation',
                  data: response['data'],
                ),
              );
            } else {
              // Normal successful login
              emit(
                LoginUserSuccessfull(
                  successfullMessage: response['msg'] ?? 'Login successful',
                  data: response['data'],
                ),
              );
            }
          } else {
            emit(LoginUserFailed(errorMessage: 'Invalid response format'));
          }
        } else {
          // Login failed
          emit(
            LoginUserFailed(errorMessage: response['msg'] ?? 'Login failed'),
          );
        }
      } catch (e) {
        print('Login bloc error: $e');
        String errorMessage = 'An error occurred during login';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().split('Exception:')[1].trim();
        } else {
          errorMessage = e.toString();
        }
        emit(LoginUserFailed(errorMessage: errorMessage));
      }
    });

    // Logout User
    on<LogOut>((event, emit) async {
      emit(LogingOutUser());
      try {
        final response = await loginRepository.logoutuser();
        emit(LogingOutUsersuccessfully(successfullMessage: response['msg']));
      } catch (e) {
        emit(LogingOutUserFailed(errorMessage: e.toString()));
      }
    });

    // Register User
    on<RegisterUser>((event, emit) async {
      emit(RegisteringUser());
      try {
        final response = await loginRepository.registerUser(event.character);
        emit(
          RegistrationSuccess(message: response['msg'], data: response['data']),
        );
      } catch (e) {
        emit(RegistrationFailure(error: e.toString()));
      }
    });

    // Activate Account
    on<ActivateAccount>((event, emit) async {
      emit(ActivatingAccount());
      try {
        final response = await loginRepository.activateAccount(
          event.userId,
          event.activationCode,
        );
        emit(
          ActivationSuccess(message: response['msg'], data: response['data']),
        );
      } catch (e) {
        emit(ActivationFailure(error: e.toString()));
      }
    });
  }
}
