import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/attendance_bloc.dart';
import 'pages/attendance_page.dart';
import 'repository/attendance_repository.dart';

/// Root entrypoint aplikasi.
///
/// Membuat instance [AttendanceRepository] dan menjalankan [AttendanceApp].
void main() {
  final repository = AttendanceRepository();
  runApp(AttendanceApp(repository: repository));
}

/// Widget utama aplikasi yang menyiapkan dependensi global.
///
/// Menggunakan [RepositoryProvider] untuk menyediakan repository ke seluruh
/// widget tree, dan [BlocProvider] untuk membuat instance [AttendanceBloc].
class AttendanceApp extends StatefulWidget {
  final AttendanceRepository repository;

  const AttendanceApp({super.key, required this.repository});

  @override
  State<AttendanceApp> createState() => _AttendanceAppState();
}

class _AttendanceAppState extends State<AttendanceApp> {
  ThemeMode _themeMode = ThemeMode.light;

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _isDarkMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi RBIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF28B8B1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF28B8B1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF191919),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: RepositoryProvider.value(
        value: widget.repository,
        child: BlocProvider(
          create: (_) => AttendanceBloc(repository: widget.repository),
          child: AttendancePage(
            isDarkMode: _isDarkMode,
            onToggleTheme: _toggleTheme,
          ),
        ),
      ),
    );
  }
}
