import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'verify_phone_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterEvent(
              phoneNumber: _phoneController.text.trim(),
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.register),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPhoneVerificationSentState) {
            // Navigate to verification screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VerifyPhoneScreen(
                  phoneNumber: state.phoneNumber,
                ),
              ),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Phone number field
                    CustomTextField(
                      controller: _phoneController,
                      labelText: localizations.phoneNumber,
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 10) {
                          return localizations.invalidPhoneNumber;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      labelText: localizations.password,
                      prefixIcon: Icons.lock,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return localizations.invalidPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: localizations.confirmPassword,
                      prefixIcon: Icons.lock,
                      obscureText: !_isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.invalidPassword;
                        }
                        if (value != _passwordController.text) {
                          return localizations.passwordsDontMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: localizations.register,
                          isLoading: state is AuthLoadingState,
                          onPressed: _register,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.alreadyHaveAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
