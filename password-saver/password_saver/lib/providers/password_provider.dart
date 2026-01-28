import 'package:flutter/material.dart';
import 'package:password_saver/models/password_entry.dart';

class PasswordProvider extends ChangeNotifier {
  PasswordProvider({required this.databaseService}) {
    _loadPasswords();
  }

  final dynamic databaseService;
  List<PasswordEntry> _passwords = [];
  List<PasswordEntry> _filteredPasswords = [];
  String _searchQuery = '';

  List<PasswordEntry> get passwords => _filteredPasswords.isEmpty && _searchQuery.isEmpty
      ? _passwords
      : _filteredPasswords;

  String get searchQuery => _searchQuery;

  void _loadPasswords() {
    _passwords = databaseService.getAllPasswords();
    notifyListeners();
  }

  Future<void> addPassword(String place, String username, String password, {String? customFieldLabel, String? customField}) async {
    await databaseService.addPassword(place, username, password, customFieldLabel: customFieldLabel, customField: customField);
    _loadPasswords();
  }

  Future<void> updatePassword(int index, String place, String username, String password, {String? customFieldLabel, String? customField}) async {
    await databaseService.updatePassword(index, place, username, password, customFieldLabel: customFieldLabel, customField: customField);
    _loadPasswords();
  }

  Future<void> deletePassword(int index) async {
    await databaseService.deletePassword(index);
    _loadPasswords();
  }

  void searchPasswords(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredPasswords = [];
    } else {
      _filteredPasswords = databaseService.searchPasswords(query);
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredPasswords = [];
    notifyListeners();
  }
}
