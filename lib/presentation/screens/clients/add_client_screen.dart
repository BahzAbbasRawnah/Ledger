import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ceilingController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ceilingController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _addClient() {
    if (_formKey.currentState!.validate()) {
      double? ceiling;

      if (_ceilingController.text.isNotEmpty) {
        ceiling = double.tryParse(_ceilingController.text);
      }

      context.read<ClientBloc>().add(
            ClientAddEvent(
              name:
                  _nameController.text.isNotEmpty ? _nameController.text : null,
              phoneNumber: _phoneController.text,
              password: _passwordController.text,
              financialCeiling: ceiling,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addClient),
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.clientAddedSuccess),
                backgroundColor: AppTheme.successColor,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is ClientErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field (optional)
                CustomTextField(
                  controller: _nameController,
                  labelText: localizations.clientName,
                  prefixIcon: Icons.person,
                  hintText: localizations.optional,
                ),
                const SizedBox(height: 16),

                // Phone field
                CustomTextField(
                  controller: _phoneController,
                  labelText: localizations.clientPhone,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return localizations.invalidPhoneNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  labelText: localizations.clientPassword,
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
                    if (value == null || value.isEmpty || value.length < 6) {
                      return localizations.invalidPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Financial ceiling field (optional)
                CustomTextField(
                  controller: _ceilingController,
                  labelText: localizations.financialCeiling,
                  prefixIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  hintText: localizations.optional,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final ceiling = double.tryParse(value);
                      if (ceiling == null || ceiling < 0) {
                        return localizations.invalidAmount;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Add button
                BlocBuilder<ClientBloc, ClientState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: localizations.addClient,
                      isLoading: state is ClientLoadingState,
                      onPressed: _addClient,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
