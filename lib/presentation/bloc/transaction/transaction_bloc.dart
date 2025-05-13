import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/client_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;
  final ClientRepository clientRepository;

  TransactionBloc({
    required this.transactionRepository,
    required this.clientRepository,
  }) : super(TransactionInitialState()) {
    on<TransactionLoadAllEvent>(_onLoadAll);
    on<TransactionLoadByClientEvent>(_onLoadByClient);
    on<TransactionLoadByDateRangeEvent>(_onLoadByDateRange);
    on<TransactionAddEvent>(_onAdd);
    on<TransactionUpdateEvent>(_onUpdate);
    on<TransactionDeleteEvent>(_onDelete);
    on<TransactionLoadDetailsEvent>(_onLoadDetails);
    on<TransactionGenerateMonthlyReportEvent>(_onGenerateMonthlyReport);
    on<TransactionGenerateCustomReportEvent>(_onGenerateCustomReport);
    on<TransactionCalculateBalanceEvent>(_onCalculateBalance);
  }

  Future<void> _onLoadAll(
    TransactionLoadAllEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final transactions = transactionRepository.getAllTransactions();
      emit(TransactionLoadedState(transactions: transactions));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadByClient(
    TransactionLoadByClientEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final transactions =
          transactionRepository.getTransactionsByClientId(event.clientId);
      emit(TransactionLoadedState(transactions: transactions));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadByDateRange(
    TransactionLoadByDateRangeEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      List<TransactionModel> transactions;

      if (event.clientId != null) {
        transactions =
            transactionRepository.getTransactionsByClientAndDateRange(
          event.clientId!,
          event.startDate,
          event.endDate,
        );
      } else {
        transactions = transactionRepository.getTransactionsByDateRange(
          event.startDate,
          event.endDate,
        );
      }

      if (event.currencyCode != null) {
        transactions = transactions
            .where((t) => t.currency == event.currencyCode)
            .toList();
      }

      emit(TransactionLoadedState(transactions: transactions));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onAdd(
    TransactionAddEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      // Validate amount
      if (event.amount <= 0) {
        emit(const TransactionErrorState(
            message: 'Amount must be greater than zero'));
        return;
      }

      final transaction = await transactionRepository.addTransaction(
        clientId: event.clientId,
        type: event.type,
        amount: event.amount,
        date: event.date,
        notes: event.notes,
        receiptImagePath: event.receiptImagePath,
        currency: event.currency,
      );

      // Check if client is approaching financial ceiling
      final balance =
          transactionRepository.calculateClientBalance(event.clientId);
      final isApproachingCeiling =
          clientRepository.isApproachingCeiling(event.clientId, balance);

      emit(TransactionAddedState(
        transaction: transaction,
        isApproachingCeiling: isApproachingCeiling,
      ));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdate(
    TransactionUpdateEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final updatedTransaction =
          await transactionRepository.updateTransaction(event.transaction);
      emit(TransactionUpdatedState(transaction: updatedTransaction));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onDelete(
    TransactionDeleteEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      await transactionRepository.deleteTransaction(event.id);
      emit(TransactionDeletedState(id: event.id));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadDetails(
    TransactionLoadDetailsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final transaction = transactionRepository.getTransactionById(event.id);

      if (transaction != null) {
        emit(TransactionDetailsLoadedState(transaction: transaction));
      } else {
        emit(const TransactionErrorState(message: 'Transaction not found'));
      }
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onGenerateMonthlyReport(
    TransactionGenerateMonthlyReportEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final reportData = transactionRepository.generateMonthlyReport(
        event.year,
        event.month,
        clientId: event.clientId,
        currencyCode: event.currencyCode,
      );

      emit(TransactionReportGeneratedState(reportData: reportData));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onGenerateCustomReport(
    TransactionGenerateCustomReportEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final reportData = transactionRepository.generateCustomReport(
        event.startDate,
        event.endDate,
        clientId: event.clientId,
        currencyCode: event.currencyCode,
      );

      emit(TransactionReportGeneratedState(reportData: reportData));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }

  Future<void> _onCalculateBalance(
    TransactionCalculateBalanceEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoadingState());

    try {
      final balance = transactionRepository.calculateClientBalance(
        event.clientId,
        currencyCode: event.currencyCode,
      );

      emit(TransactionBalanceCalculatedState(
        balance: balance,
        clientId: event.clientId,
        currencyCode: event.currencyCode,
      ));
    } catch (e) {
      emit(TransactionErrorState(message: e.toString()));
    }
  }
}
