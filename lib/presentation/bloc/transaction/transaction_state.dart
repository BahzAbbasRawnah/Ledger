import 'package:equatable/equatable.dart';

import '../../../data/models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  final List<TransactionModel> transactions;

  const TransactionLoadedState({
    required this.transactions,
  });

  @override
  List<Object?> get props => [transactions];
}

class TransactionDetailsLoadedState extends TransactionState {
  final TransactionModel transaction;

  const TransactionDetailsLoadedState({
    required this.transaction,
  });

  @override
  List<Object?> get props => [transaction];
}

class TransactionAddedState extends TransactionState {
  final TransactionModel transaction;
  final bool isApproachingCeiling;

  const TransactionAddedState({
    required this.transaction,
    this.isApproachingCeiling = false,
  });

  @override
  List<Object?> get props => [transaction, isApproachingCeiling];
}

class TransactionUpdatedState extends TransactionState {
  final TransactionModel transaction;

  const TransactionUpdatedState({
    required this.transaction,
  });

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeletedState extends TransactionState {
  final String id;

  const TransactionDeletedState({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class TransactionErrorState extends TransactionState {
  final String message;

  const TransactionErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class TransactionReportGeneratedState extends TransactionState {
  final Map<String, dynamic> reportData;

  const TransactionReportGeneratedState({
    required this.reportData,
  });

  @override
  List<Object?> get props => [reportData];
}

class TransactionBalanceCalculatedState extends TransactionState {
  final double balance;
  final String clientId;
  final String? currencyCode;

  const TransactionBalanceCalculatedState({
    required this.balance,
    required this.clientId,
    this.currencyCode,
  });

  @override
  List<Object?> get props => [balance, clientId, currencyCode];
}
