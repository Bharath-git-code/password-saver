import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_saver/services/database_service.dart';
import 'package:password_saver/providers/password_provider.dart';
import 'package:password_saver/screens/home_screen.dart';
import 'package:password_saver/screens/add_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final databaseService = DatabaseService();
  await databaseService.init();
  
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PasswordProvider(databaseService: databaseService),
        ),
      ],
      child: MaterialApp(
        title: 'Password Saver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == '/add-password') {
            final args = settings.arguments as int?;
            return MaterialPageRoute(
              builder: (context) => AddPasswordScreen(editIndex: args),
            );
          }
          return null;
        },
      ),
    );
  }
}
