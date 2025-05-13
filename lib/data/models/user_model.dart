import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String phoneNumber;
  
  @HiveField(2)
  final String? businessName;
  
  @HiveField(3)
  final String? businessPhone;
  
  @HiveField(4)
  final String? businessLogo;
  
  @HiveField(5)
  final DateTime registrationDate;
  
  @HiveField(6)
  final DateTime trialEndDate;
  
  @HiveField(7)
  final bool isPremium;
  
  @HiveField(8)
  final String? preferredCurrency;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.businessName,
    this.businessPhone,
    this.businessLogo,
    required this.registrationDate,
    required this.trialEndDate,
    this.isPremium = false,
    this.preferredCurrency = 'USD',
  });

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? businessName,
    String? businessPhone,
    String? businessLogo,
    DateTime? registrationDate,
    DateTime? trialEndDate,
    bool? isPremium,
    String? preferredCurrency,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessName: businessName ?? this.businessName,
      businessPhone: businessPhone ?? this.businessPhone,
      businessLogo: businessLogo ?? this.businessLogo,
      registrationDate: registrationDate ?? this.registrationDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      isPremium: isPremium ?? this.isPremium,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'businessName': businessName,
      'businessPhone': businessPhone,
      'businessLogo': businessLogo,
      'registrationDate': registrationDate.toIso8601String(),
      'trialEndDate': trialEndDate.toIso8601String(),
      'isPremium': isPremium,
      'preferredCurrency': preferredCurrency,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      businessName: json['businessName'],
      businessPhone: json['businessPhone'],
      businessLogo: json['businessLogo'],
      registrationDate: DateTime.parse(json['registrationDate']),
      trialEndDate: DateTime.parse(json['trialEndDate']),
      isPremium: json['isPremium'] ?? false,
      preferredCurrency: json['preferredCurrency'] ?? 'USD',
    );
  }

  @override
  List<Object?> get props => [
    id, 
    phoneNumber, 
    businessName, 
    businessPhone, 
    businessLogo, 
    registrationDate, 
    trialEndDate, 
    isPremium, 
    preferredCurrency
  ];
}
