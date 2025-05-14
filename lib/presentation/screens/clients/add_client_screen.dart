import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../utils/snackbar_utils.dart';
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
            SnackBarUtils.showSuccessSnackBar(
              context,
              message: localizations.clientAddedSuccess,
            );

            Navigator.of(context).pop();
          } else if (state is ClientErrorState) {
            SnackBarUtils.showErrorSnackBar(
              context,
              message: state.message,
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

class AddClientBottomSheet extends StatefulWidget {
  const AddClientBottomSheet({super.key});

  @override
  State<AddClientBottomSheet> createState() => _AddClientBottomSheetState();
}

class _AddClientBottomSheetState extends State<AddClientBottomSheet> {
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

    return BlocListener<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientAddedState) {
          SnackBarUtils.showSuccessSnackBar(
            context,
            message: localizations.clientAddedSuccess,
          );

          Navigator.of(context).pop();
        } else if (state is ClientErrorState) {
          SnackBarUtils.showErrorSnackBar(
            context,
            message: state.message,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.addClient,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Form
            Form(
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
                  const SizedBox(height: 24),

                  // Add button
                  Center(
                    child: BlocBuilder<ClientBloc, ClientState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: localizations.addClient,
                          isLoading: state is ClientLoadingState,
                          onPressed: _addClient,
                          widthPercentage: 70, // 70% of screen width
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
