import 'package:hive/hive.dart';

part 'password_entry.g.dart';

@HiveType(typeId: 0)
class PasswordEntry extends HiveObject {
  @HiveField(0)
  late String place;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String password;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  late String? customField;

  @HiveField(5)
  late String? customFieldLabel;

  PasswordEntry({
    required this.place,
    required this.username,
    required this.password,
    required this.createdAt,
    this.customField,
    this.customFieldLabel,
  });
}
