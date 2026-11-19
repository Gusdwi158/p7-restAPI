import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'services/course_data_source.dart';
import 'services/course_api_service.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_page.dart';

// Mahasiswa: I Kadek Agus Dwi Adnyana (NIM: 2415051076)
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';
const bool useSupabase = true; // Ubah ke false untuk beralih ke REST API

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Switching sumber data cukup pada 1 baris ini tanpa mengubah Repository/Provider/UI:
  final CourseDataSource dataSource = useSupabase
      ? CourseSupabaseService()
      : CourseApiService(apiBaseUrl);

  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
