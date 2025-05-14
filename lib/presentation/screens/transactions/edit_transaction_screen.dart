import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/transaction_model.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late String _transactionType;
  late DateTime _selectedDate;
  late String _selectedCurrency;
  String? _receiptImagePath;
  XFile? _newReceiptImage;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with transaction data
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _notesController = TextEditingController(
      text: widget.transaction.notes ?? '',
    );
    _transactionType = widget.transaction.type;
    _selectedDate = widget.transaction.date;
    _selectedCurrency = widget.transaction.currency;
    _receiptImagePath = widget.transaction.receiptImagePath;
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
        _newReceiptImage = pickedFile;
        _receiptImagePath = null; // Clear old receipt path
      });
    }
  }

  void _updateTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

      // Determine receipt image path
      final String? finalReceiptPath =
          _newReceiptImage?.path ?? _receiptImagePath;

      final updatedTransaction = widget.transaction.copyWith(
        type: _transactionType,
        amount: amount,
        date: _selectedDate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        receiptImagePath: finalReceiptPath,
        currency: _selectedCurrency,
      );

      context.read<TransactionBloc>().add(
            TransactionUpdateEvent(transaction: updatedTransaction),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editTransaction),
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionUpdatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.transactionUpdatedSuccess),
                backgroundColor: AppTheme.successColor,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is TransactionErrorState) {
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
                // Transaction type
                Text(
                  localizations.transactionType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
                  prefixIcon: Icons.note,
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
                if (_newReceiptImage != null)
                  // Show newly picked image
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
                            File(_newReceiptImage!.path),
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
                              _newReceiptImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_receiptImagePath != null)
                  // Show existing receipt
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
                            File(_receiptImagePath!),
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
                              _receiptImagePath = null;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else
                  // No receipt, show add button
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(localizations.addReceipt),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                const SizedBox(height: 32),

                // Update button
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: localizations.save,
                      isLoading: state is TransactionLoadingState,
                      onPressed: _updateTransaction,
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
