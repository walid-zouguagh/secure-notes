import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart'; // Add 'intl' to pubspec.yaml for date formatting
import '../models/note.dart';
import '../services/database_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Function to show the Date Picker (as seen in your screenshot)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveNote(AppLocalizations l10n) async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        orderIndex: 0, // This will be correctly set by DatabaseService.addNote
      );

      await DatabaseService.instance.addNote(newNote);
      if (mounted) Navigator.pop(context, true); // Return to home and signal success
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addNote),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: l10n.title,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? l10n.enterTitle : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? l10n.enterDescription : null,
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        title: Text("${l10n.date}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                        tileColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => _saveNote(l10n),
                child: Text(l10n.save, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 25), // Moves button above bottom bar
          ],
        ),
      ),
    );
  }
}