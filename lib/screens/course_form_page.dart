import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  const CourseFormPage({super.key});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _selectedStatus = 'planned';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CourseProvider>();
    if (provider.isSaving) return;

    final newCourse = Course(
      code: _codeController.text.trim().toUpperCase(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    try {
      await provider.addCourse(newCourse);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menambah course: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Course'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '2415051076 • I Kadek Agus Dwi Adnyana',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                enabled: !isSaving,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Kode Course (misal: MOB10)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode course wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                enabled: !isSaving,
                decoration: const InputDecoration(
                  labelText: 'Judul Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul course wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                enabled: !isSaving,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS (Credits)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah SKS wajib diisi';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Credits harus berupa angka lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('planned')),
                  DropdownMenuItem(value: 'active', child: Text('active')),
                  DropdownMenuItem(value: 'done', child: Text('done')),
                ],
                onChanged: isSaving
                    ? null
                    : (val) {
                        if (val != null) {
                          setState(() => _selectedStatus = val);
                        }
                      },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                  icon: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
