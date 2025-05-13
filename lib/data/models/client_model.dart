import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'client_model.g.dart';

@HiveType(typeId: 1)
class ClientModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String? name;
  
  @HiveField(2)
  final String phoneNumber;
  
  @HiveField(3)
  final String password;
  
  @HiveField(4)
  final double financialCeiling;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final DateTime updatedAt;

  const ClientModel({
    required this.id,
    this.name,
    required this.phoneNumber,
    required this.password,
    this.financialCeiling = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  ClientModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? password,
    double? financialCeiling,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      financialCeiling: financialCeiling ?? this.financialCeiling,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'financialCeiling': financialCeiling,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      financialCeiling: json['financialCeiling'] ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id, 
    name, 
    phoneNumber, 
    password, 
    financialCeiling, 
    createdAt, 
    updatedAt
  ];
}
