import 'package:equatable/equatable.dart';

import '../../../data/models/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionLoadAllEvent extends TransactionEvent {}

class TransactionLoadByClientEvent extends TransactionEvent {
  final String clientId;

  const TransactionLoadByClientEvent({
    required this.clientId,
  });

  @override
  List<Object?> get props => [clientId];
}

class TransactionLoadByDateRangeEvent extends TransactionEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? clientId;
  final String? currencyCode;

  const TransactionLoadByDateRangeEvent({
    required this.startDate,
    required this.endDate,
    this.clientId,
    this.currencyCode,
  });

  @override
  List<Object?> get props => [startDate, endDate, clientId, currencyCode];
}

class TransactionAddEvent extends TransactionEvent {
  final String clientId;
  final String type;
  final double amount;
  final DateTime date;
  final String? notes;
  final String? receiptImagePath;
  final String currency;

  const TransactionAddEvent({
    required this.clientId,
    required this.type,
    required this.amount,
    required this.date,
    this.notes,
    this.receiptImagePath,
    required this.currency,
  });

  @override
  List<Object?> get props => [
    clientId,
    type,
    amount,
    date,
    notes,
    receiptImagePath,
    currency,
  ];
}

class TransactionUpdateEvent extends TransactionEvent {
  final TransactionModel transaction;

  const TransactionUpdateEvent({
    required this.transaction,
  });

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleteEvent extends TransactionEvent {
  final String id;

  const TransactionDeleteEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class TransactionLoadDetailsEvent extends TransactionEvent {
  final String id;

  const TransactionLoadDetailsEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class TransactionGenerateMonthlyReportEvent extends TransactionEvent {
  final int year;
  final int month;
  final String? clientId;
  final String? currencyCode;

  const TransactionGenerateMonthlyReportEvent({
    required this.year,
    required this.month,
    this.clientId,
    this.currencyCode,
  });

  @override
  List<Object?> get props => [year, month, clientId, currencyCode];
}

class TransactionGenerateCustomReportEvent extends TransactionEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? clientId;
  final String? currencyCode;

  const TransactionGenerateCustomReportEvent({
    required this.startDate,
    required this.endDate,
    this.clientId,
    this.currencyCode,
  });

  @override
  List<Object?> get props => [startDate, endDate, clientId, currencyCode];
}

class TransactionCalculateBalanceEvent extends TransactionEvent {
  final String clientId;
  final String? currencyCode;

  const TransactionCalculateBalanceEvent({
    required this.clientId,
    this.currencyCode,
  });

  @override
  List<Object?> get props => [clientId, currencyCode];
}
