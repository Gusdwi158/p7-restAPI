import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;
  final Set<String> favorites = {};

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourse(Course course) async {
    if (isSaving) return;

    isSaving = true;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> editCourse(int id, Course course) async {
    if (isSaving) return;

    isSaving = true;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await loadCourses();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> removeCourse(Course course) async {
    if (isSaving) return;
    final courseId = course.id;
    if (courseId == null) {
      throw Exception('ID course tidak valid untuk dihapus');
    }

    isSaving = true;
    notifyListeners();

    try {
      await repository.deleteCourse(courseId);
      // Hapus juga dari favorites agar tidak tersisa data yatim
      favorites.remove(course.code);
      await loadCourses();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  bool isFavorite(String code) {
    return favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }

  int get favoriteCount => favorites.length;

  List<Course> get favoriteCourses {
    return courses.where((c) => favorites.contains(c.code)).toList();
  }
}
