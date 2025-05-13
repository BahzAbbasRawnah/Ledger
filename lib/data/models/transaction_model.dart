import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String clientId;
  
  @HiveField(2)
  final String type; // 'incoming' or 'outgoing'
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final DateTime date;
  
  @HiveField(5)
  final String? notes;
  
  @HiveField(6)
  final String? receiptImagePath;
  
  @HiveField(7)
  final String currency;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.clientId,
    required this.type,
    required this.amount,
    required this.date,
    this.notes,
    this.receiptImagePath,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionModel copyWith({
    String? id,
    String? clientId,
    String? type,
    double? amount,
    DateTime? date,
    String? notes,
    String? receiptImagePath,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      'receiptImagePath': receiptImagePath,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      clientId: json['clientId'],
      type: json['type'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      receiptImagePath: json['receiptImagePath'],
      currency: json['currency'] ?? 'USD',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id, 
    clientId, 
    type, 
    amount, 
    date, 
    notes, 
    receiptImagePath, 
    currency, 
    createdAt, 
    updatedAt
  ];
}
