import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/intro_screen.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';
import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'DayTask',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while initializing
        if (!authProvider.isInitialized) {
          return const Scaffold(
            backgroundColor: AppTheme.darkBackground,
            body: Center(
              child: CircularProgressIndicator(
                color: AppTheme.yellowAccent,
              ),
            ),
          );
        }

        // Show dashboard if authenticated, otherwise show intro
        if (authProvider.isAuthenticated) {
          // Load tasks when authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final taskProvider = context.read<TaskProvider>();
            taskProvider.streamTasks(authProvider.currentUser!.id);
          });
          return const DashboardScreen();
        }

        return const IntroScreen();
      },
    );
  }
}
