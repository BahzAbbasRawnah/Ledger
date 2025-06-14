import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  final String? clientId;

  const AddTransactionScreen({
    super.key,
    this.clientId,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedClientId;
  String _transactionType = AppConstants.transactionTypeCredit;
  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = 'YER';
  XFile? _receiptImage;
  List<ClientModel> _clients = [];

  @override
  void initState() {
    super.initState();

    // Set client ID if provided
    _selectedClientId = widget.clientId;

    // Load clients
    context.read<ClientBloc>().add(ClientLoadAllEvent());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _receiptImage = pickedFile;
      });
    }
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClientId == null) {
        SnackBarUtils.showErrorSnackBar(
          context,
          message: AppLocalizations.of(context).selectClientFirst,
        );
        return;
      }

      final amount = double.parse(_amountController.text);

      context.read<TransactionBloc>().add(
            TransactionAddEvent(
              clientId: _selectedClientId!,
              type: _transactionType,
              amount: amount,
              date: _selectedDate,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
              receiptImagePath: _receiptImage?.path,
              currency: _selectedCurrency,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addTransaction),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionAddedState) {
                SnackBarUtils.showSuccessSnackBar(
                  context,
                  message: localizations.transactionAddedSuccess,
                );

                if (state.isApproachingCeiling) {
                  SnackBarUtils.showWarningSnackBar(
                    context,
                    message: localizations.ceilingWarning,
                  );
                }

                Navigator.of(context).pop();
              } else if (state is TransactionErrorState) {
                SnackBarUtils.showErrorSnackBar(
                  context,
                  message: state.message,
                );
              }
            },
          ),
          BlocListener<ClientBloc, ClientState>(
            listener: (context, state) {
              if (state is ClientLoadedState) {
                setState(() {
                  _clients = state.clients;
                });
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client selection
                if (widget.clientId == null) _buildClientDropdown(context),

              
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: AppConstants.transactionTypeCredit,
                      label: Text(localizations.Credit),
                      icon: const Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment<String>(
                      value: AppConstants.transactionTypeDebit,
                      label: Text(localizations.Debit),
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_transactionType},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _transactionType = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Amount and currency
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        controller: _amountController,
                        labelText: localizations.amount,
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.amountRequired;
                          }

                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return localizations.invalidAmount;
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: localizations.currency,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: _selectedCurrency,
                        items: AppConstants.supportedCurrencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency['code'] as String,
                            child: Text(
                                '${currency['code']} (${currency['symbol']})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrency = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: localizations.date,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                CustomTextField(
                  controller: _notesController,
                  labelText: localizations.notes,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Receipt image
                Text(
                  localizations.receipt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_receiptImage != null)
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_receiptImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: AppTheme.errorColor,
                          onPressed: () {
                            setState(() {
                              _receiptImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(localizations.addReceipt),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                const SizedBox(height: 32),

                // Add button
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: localizations.addTransaction,
                      isLoading: state is TransactionLoadingState,
                      onPressed: _addTransaction,
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

  Widget _buildClientDropdown(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.selectClient,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
          value: _selectedClientId,
          hint: Text(localizations.selectClient),
          items: _clients.map((client) {
            return DropdownMenuItem<String>(
              value: client.id,
              child: Text(client.name ?? client.phoneNumber),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedClientId = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return localizations.selectClientFirst;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}


class AddTransactionBottomSheet extends StatefulWidget {
  /// The ID of the client for which to add a transaction.
  final String clientId;

  const AddTransactionBottomSheet({
    super.key,
    required this.clientId,
  });

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _transactionType = AppConstants.transactionTypeCredit;
  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = 'USD';
  XFile? _receiptImage;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _receiptImage = pickedFile;
      });
    }
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

      context.read<TransactionBloc>().add(
            TransactionAddEvent(
              clientId: widget.clientId,
              type: _transactionType,
              amount: amount,
              date: _selectedDate,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
              receiptImagePath: _receiptImage?.path,
              currency: _selectedCurrency,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Bottom sheet header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.addTransaction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Transaction form content
          Expanded(
            child: BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionAddedState) {
                  SnackBarUtils.showSuccessSnackBar(
                    context,
                    message: localizations.transactionAddedSuccess,
                  );

                  if (state.isApproachingCeiling) {
                    SnackBarUtils.showWarningSnackBar(
                      context,
                      message: localizations.ceilingWarning,
                    );
                  }

                  Navigator.of(context).pop();
                } else if (state is TransactionErrorState) {
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
                     
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment<String>(
                            value: AppConstants.transactionTypeCredit,
                            label: Text(localizations.Credit),
                            icon: const Icon(Icons.arrow_downward),
                          ),
                          ButtonSegment<String>(
                            value: AppConstants.transactionTypeDebit,
                            label: Text(localizations.Debit),
                            icon: const Icon(Icons.arrow_upward),
                          ),
                        ],
                        selected: {_transactionType},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            _transactionType = selection.first;
                          });
                        },
                       style: ButtonStyle(
                        shape: WidgetStateProperty.fromMap(
                          {
                            WidgetState.selected: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            WidgetState.any: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                           
                          },
                        ),
                        backgroundColor: WidgetStateColor.fromMap( {
                          WidgetState.selected: AppTheme.primaryColor,
                          WidgetState.any: Colors.grey[200]!,
                        },
                        ),
                       ),
                      
                        
                      ),
                      const SizedBox(height: 16),

                      // Amount and currency
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              controller: _amountController,
                              labelText: localizations.amount,
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return localizations.amountRequired;
                                }

                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return localizations.invalidAmount;
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: localizations.currency,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: _selectedCurrency,
                              items: AppConstants.supportedCurrencies
                                  .map((currency) {
                                return DropdownMenuItem<String>(
                                  value: currency['code'] as String,
                                  child: Text(
                                      '${currency['code']} (${currency['symbol']})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCurrency = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: localizations.date,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            DateFormat.yMMMd().format(_selectedDate),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      CustomTextField(
                        controller: _notesController,
                        labelText: localizations.notes,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Receipt image
                      Text(
                        localizations.receipt,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_receiptImage != null)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_receiptImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                color: AppTheme.errorColor,
                                onPressed: () {
                                  setState(() {
                                    _receiptImage = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.add_a_photo),
                          label: Text(localizations.addReceipt),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Add button
                      Center(
                        child: BlocBuilder<TransactionBloc, TransactionState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: localizations.addTransaction,
                              isLoading: state is TransactionLoadingState,
                              onPressed: _addTransaction,
                              widthPercentage: 70, // 70% of screen width
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
