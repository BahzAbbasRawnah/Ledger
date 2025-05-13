import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyPhoneScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();

    if (code.length == 6) {
      context.read<AuthBloc>().add(
            AuthVerifyPhoneEvent(
              phoneNumber: widget.phoneNumber,
              verificationCode: code,
            ),
          );
    }
  }

  void _resendCode() {
    // In a real app, we would resend the verification code
    // For this simulation, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).verificationCodeSent),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.verifyPhone),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistrationSuccessState) {
            // Navigate to home screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is AuthErrorState) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Text(
                  localizations.verificationCodeSent,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Phone number
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Verification code input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }

                          if (_controllers.every((c) => c.text.isNotEmpty)) {
                            _verifyCode();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Verify button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: localizations.verifyPhone,
                      isLoading: state is AuthLoadingState,
                      onPressed: _verifyCode,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Resend code button
                Center(
                  child: TextButton(
                    onPressed: _resendCode,
                    child: Text(localizations.resendCode),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
