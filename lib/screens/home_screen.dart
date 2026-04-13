import 'package:flutter/material.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import 'package:secure_notes/screens/add_note_screen.dart';
import 'package:secure_notes/screens/edit_note_screen.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  Future<void> _refreshNotes() async {
    final data = await DatabaseService.instance.getAllNotes();
    setState(() {
      _notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final currentLocale = Localizations.localeOf(context);
              final newLocale = currentLocale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
              MyApp.of(context)?.setLocale(newLocale);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              // Delete All functionality
              await DatabaseService.instance.deleteAllNotes();
              _refreshNotes();
            },
          ),
        ],
      ),
      body: _notes.isEmpty
          ? Center(child: Text(l10n.noNotes))
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notes.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _notes.removeAt(oldIndex);
                  _notes.insert(newIndex, item);
                });

                DatabaseService.instance.updateAllNotes(_notes);
              },
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    await DatabaseService.instance.deleteNote(note.id!);
                    _refreshNotes();
                  },
                  child: Card(
                    key: ValueKey(note.id),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(note.description),
                      trailing: Text(
                        note.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () async {
                        bool? updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNoteScreen(
                              note: note,
                            ),
                          ),
                        );

                        if (updated == true) {
                          _refreshNotes();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          bool? saved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );

          if (saved == true) {
            _refreshNotes();
          }
        },
      ),
    );
  }
}
