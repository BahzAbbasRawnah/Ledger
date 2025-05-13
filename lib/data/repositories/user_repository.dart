import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  final Box<UserModel> _userBox;
  
  UserRepository(this._userBox);
  
  // Get current user
  UserModel? getCurrentUser() {
    if (_userBox.isEmpty) return null;
    return _userBox.getAt(0);
  }
  
  // Register new user
  Future<UserModel> registerUser(String phoneNumber, String password) async {
    // In a real app, we would validate the phone number and password
    // and make an API call to register the user
    
    // For this simulation, we'll create a new user locally
    final now = DateTime.now();
    final trialEndDate = now.add(Duration(days: AppConstants.trialPeriodDays));
    
    final user = UserModel(
      id: const Uuid().v4(),
      phoneNumber: phoneNumber,
      registrationDate: now,
      trialEndDate: trialEndDate,
    );
    
    await _userBox.add(user);
    return user;
  }
  
  // Login user
  Future<UserModel?> loginUser(String phoneNumber, String password) async {
    // In a real app, we would validate the credentials against an API
    
    // For this simulation, we'll just return the current user if it exists
    // and the phone number matches
    final currentUser = getCurrentUser();
    if (currentUser != null && currentUser.phoneNumber == phoneNumber) {
      return currentUser;
    }
    return null;
  }
  
  // Update user information
  Future<UserModel> updateUser(UserModel updatedUser) async {
    await _userBox.putAt(0, updatedUser);
    return updatedUser;
  }
  
  // Update business information
  Future<UserModel> updateBusinessInfo({
    required String businessName,
    required String businessPhone,
    String? businessLogo,
  }) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user found');
    }
    
    final updatedUser = currentUser.copyWith(
      businessName: businessName,
      businessPhone: businessPhone,
      businessLogo: businessLogo,
    );
    
    await _userBox.putAt(0, updatedUser);
    return updatedUser;
  }
  
  // Update preferred currency
  Future<UserModel> updatePreferredCurrency(String currencyCode) async {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user found');
    }
    
    final updatedUser = currentUser.copyWith(
      preferredCurrency: currencyCode,
    );
    
    await _userBox.putAt(0, updatedUser);
    return updatedUser;
  }
  
  // Upgrade to premium
  Future<UserModel> upgradeToPremium() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      throw Exception('No user found');
    }
    
    final updatedUser = currentUser.copyWith(
      isPremium: true,
    );
    
    await _userBox.putAt(0, updatedUser);
    return updatedUser;
  }
  
  // Logout user
  Future<void> logoutUser() async {
    // In a real app, we would clear tokens and make API calls
    
    // For this simulation, we'll just clear the user box
    await _userBox.clear();
  }
}
