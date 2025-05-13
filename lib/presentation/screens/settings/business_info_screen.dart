import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  String? _businessLogoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBusinessInfo();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessPhoneController.dispose();
    super.dispose();
  }

  void _loadBusinessInfo() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticatedState) {
      _businessNameController.text = authState.user.businessName ?? '';
      _businessPhoneController.text = authState.user.businessPhone ?? '';
      _businessLogoPath = authState.user.businessLogo;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _businessLogoPath = pickedFile.path;
      });
    }
  }

  void _saveBusinessInfo() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<AuthBloc>().add(
            AuthUpdateBusinessInfoEvent(
              businessName: _businessNameController.text,
              businessPhone: _businessPhoneController.text,
              businessLogo: _businessLogoPath,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.businessInfo),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthBusinessInfoUpdatedState) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.businessInfoUpdated),
                backgroundColor: AppTheme.successColor,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is AuthErrorState) {
            setState(() {
              _isLoading = false;
            });

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
                // Business logo
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _businessLogoPath != null
                              ? FileImage(File(_businessLogoPath!))
                              : null,
                          child: _businessLogoPath == null
                              ? const Icon(
                                  Icons.business,
                                  size: 60,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_camera),
                        label: Text(localizations.changePhoto),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Business name
                CustomTextField(
                  controller: _businessNameController,
                  labelText: localizations.businessName,
                  prefixIcon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.businessNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Business phone
                CustomTextField(
                  controller: _businessPhoneController,
                  labelText: localizations.businessPhone,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.businessPhoneRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save button
                CustomButton(
                  text: localizations.save,
                  isLoading: _isLoading,
                  onPressed: _saveBusinessInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
