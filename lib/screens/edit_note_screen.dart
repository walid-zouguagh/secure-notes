import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(text: widget.note.description);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.note.date);
  }

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

  void _updateNote() async {
    if (_formKey.currentState!.validate()) {
      final updatedNote = Note(
        id: widget.note.id, 
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        orderIndex: widget.note.orderIndex, 
      );

      await DatabaseService.instance.updateNote(updatedNote);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editNote),
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
                        decoration: InputDecoration(labelText: l10n.title, border: const OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? l10n.enterTitle : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: l10n.description, border: const OutlineInputBorder()),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? l10n.enterDescription : null,
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        title: Text("${l10n.date}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                        tileColor: Colors.grey[200],
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                onPressed: _updateNote,
                child: Text(l10n.updateChanges),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}