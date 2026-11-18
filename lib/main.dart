import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/course_data_source.dart';
import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_page.dart';

// Mahasiswa: I Kadek Agus Dwi Adnyana (NIM: 2415051076)
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

void main() {
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);
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
