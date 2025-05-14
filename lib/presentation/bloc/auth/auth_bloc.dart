import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  final SharedPreferences sharedPreferences;

  AuthBloc({
    required this.userRepository,
    required this.sharedPreferences,
  }) : super(AuthInitialState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthVerifyPhoneEvent>(_onVerifyPhone);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthUpdateBusinessInfoEvent>(_onUpdateBusinessInfo);
    on<AuthUpdateCurrencyEvent>(_onUpdateCurrency);
    on<AuthUpgradeToPremiumEvent>(_onUpgradeToPremium);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final isLoggedIn =
          sharedPreferences.getBool(AppConstants.prefIsLoggedIn) ?? false;

      if (isLoggedIn) {
        final user = userRepository.getCurrentUser();

        if (user != null) {
          emit(AuthAuthenticatedState(user: user));
        } else {
          // User data not found in Hive, clear preferences
          await sharedPreferences.setBool(AppConstants.prefIsLoggedIn, false);
          emit(AuthUnauthenticatedState());
        }
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      // Validate phone number (simple validation)
      if (event.phoneNumber.isEmpty || event.phoneNumber.length < 10) {
        emit(const AuthErrorState(message: 'Invalid phone number'));
        return;
      }

      // Validate password
      if (event.password.isEmpty || event.password.length < 6) {
        emit(const AuthErrorState(
            message: 'Password must be at least 6 characters'));
        return;
      }

      // Attempt login
      final user =
          await userRepository.loginUser(event.phoneNumber, event.password);

      if (user != null) {
        // Save login status
        await sharedPreferences.setBool(AppConstants.prefIsLoggedIn, true);
        await sharedPreferences.setString(AppConstants.prefUserId, user.id);
        await sharedPreferences.setString(
            AppConstants.prefUserPhone, user.phoneNumber);

        emit(AuthAuthenticatedState(user: user));
      } else {
        emit(const AuthErrorState(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      // Validate phone number (simple validation)
      if (event.phoneNumber.isEmpty || event.phoneNumber.length < 10) {
        emit(const AuthErrorState(message: 'Invalid phone number'));
        return;
      }

      // Validate password
      if (event.password.isEmpty || event.password.length < 6) {
        emit(const AuthErrorState(
            message: 'Password must be at least 6 characters'));
        return;
      }

      // Validate password confirmation
      if (event.password != event.confirmPassword) {
        emit(const AuthErrorState(message: 'Passwords do not match'));
        return;
      }

      // In a real app, we would send a verification code to the phone number
      // For this simulation, we'll just emit the verification sent state
      emit(AuthPhoneVerificationSentState(phoneNumber: event.phoneNumber));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onVerifyPhone(
    AuthVerifyPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      // In a real app, we would verify the code with an API
      // For this simulation, we'll accept any 6-digit code
      if (event.verificationCode.length != 6) {
        emit(const AuthErrorState(message: 'Invalid verification code'));
        return;
      }

      // Add a small delay to simulate network request
      await Future.delayed(const Duration(seconds: 1));

      // Register the user
      final user =
          await userRepository.registerUser(event.phoneNumber, 'password');

      // Save login status
      await sharedPreferences.setBool(AppConstants.prefIsLoggedIn, true);
      await sharedPreferences.setString(AppConstants.prefUserId, user.id);
      await sharedPreferences.setString(
          AppConstants.prefUserPhone, user.phoneNumber);

      // First emit registration success state (for listeners in the verify screen)
      emit(AuthRegistrationSuccessState(user: user));

      // Then emit authenticated state (for the home screen)
      emit(AuthAuthenticatedState(user: user));
    } catch (e) {
      print('Error during phone verification: $e');
      emit(AuthErrorState(message: 'Failed to verify phone: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      await userRepository.logoutUser();

      // Clear preferences
      await sharedPreferences.setBool(AppConstants.prefIsLoggedIn, false);
      await sharedPreferences.remove(AppConstants.prefUserId);
      await sharedPreferences.remove(AppConstants.prefUserPhone);

      emit(AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateBusinessInfo(
    AuthUpdateBusinessInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final updatedUser = await userRepository.updateBusinessInfo(
        businessName: event.businessName,
        businessPhone: event.businessPhone,
        businessLogo: event.businessLogo,
      );

      emit(AuthBusinessInfoUpdatedState(user: updatedUser));
      emit(AuthAuthenticatedState(user: updatedUser));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateCurrency(
    AuthUpdateCurrencyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final updatedUser =
          await userRepository.updatePreferredCurrency(event.currencyCode);

      emit(AuthCurrencyUpdatedState(user: updatedUser));
      emit(AuthAuthenticatedState(user: updatedUser));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpgradeToPremium(
    AuthUpgradeToPremiumEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final updatedUser = await userRepository.upgradeToPremium();

      emit(AuthPremiumUpgradedState(user: updatedUser));
      emit(AuthAuthenticatedState(user: updatedUser));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
