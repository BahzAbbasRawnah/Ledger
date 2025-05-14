import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditClientScreen extends StatefulWidget {
  final ClientModel client;

  const EditClientScreen({
    super.key,
    required this.client,
  });

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _ceilingController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name ?? '');
    _phoneController = TextEditingController(text: widget.client.phoneNumber);
    _passwordController = TextEditingController(text: widget.client.password);
    _ceilingController = TextEditingController(
      text: widget.client.financialCeiling > 0
          ? widget.client.financialCeiling.toString()
          : '',
    );
  }

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

  void _updateClient() {
    if (_formKey.currentState!.validate()) {
      double? ceiling;

      if (_ceilingController.text.isNotEmpty) {
        ceiling = double.tryParse(_ceilingController.text);
      }

      final updatedClient = widget.client.copyWith(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
        financialCeiling: ceiling ?? 0.0,
      );

      context.read<ClientBloc>().add(
            ClientUpdateEvent(client: updatedClient),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editClient),
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientUpdatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.clientUpdatedSuccess),
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

                // Update button
                BlocBuilder<ClientBloc, ClientState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: localizations.save,
                      isLoading: state is ClientLoadingState,
                      onPressed: _updateClient,
                      widthPercentage: 70, // 70% of screen width
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
