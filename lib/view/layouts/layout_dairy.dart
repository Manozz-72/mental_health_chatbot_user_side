import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/note.dart';
import '../../services/note_services.dart';


class LayoutDairy extends StatefulWidget {
  const LayoutDairy({super.key});

  @override
  State<LayoutDairy> createState() => _LayoutDairyState();
}

class _LayoutDairyState extends State<LayoutDairy> {
  final _svc = NoteService();
  final _df = DateFormat('EEE, d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Dairy", style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xff21AF85),
        elevation: 0,
      ),
      body: StreamBuilder<List<Note>>(
        stream: _svc.streamNotes(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final notes = snap.data ?? [];
          if (notes.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, i) {
              final n = notes[i];
              return Dismissible(
                key: ValueKey(n.id),
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete note?'),
                      content:
                      const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete')),
                      ],
                    ),
                  ) ??
                      false;
                },
                onDismissed: (_) => _svc.deleteNote(n.id),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                    ),
                  ),
                  title: Text(
                    n.emotion.isEmpty ? 'No emotion' : n.emotion,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      n.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit, size: 18),
                      const SizedBox(height: 4),
                      Text(_df.format(n.date), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  onTap: () => _openEditor(context, existing: n),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: notes.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        label: const Text('Add note'),
        backgroundColor: Color(0xff21AF85),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {Note? existing}) async {
    final emotionCtrl = TextEditingController(text: existing?.emotion ?? '');
    final textCtrl = TextEditingController(text: existing?.text ?? '');
    DateTime selectedDate = existing?.date ?? DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  existing == null ? 'Add Note' : 'Edit Note',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                // Emotion row (quick chips + custom input)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in const [
                        'Happy 😊',
                        'Sad 😔',
                        'Anxious 😟',
                        'Calm 😌',
                        'Angry 😡',
                        'Grateful 🙏'
                      ])
                        ChoiceChip(
                          label: Text(e),
                          selected: emotionCtrl.text == e,
                          onSelected: (_) {
                            setSheetState(() => emotionCtrl.text = e);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emotionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Emotion (or choose above)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Date picker
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setSheetState(() => selectedDate = picked);
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: Text(_df.format(selectedDate)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: textCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Write your thoughts/feelings',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final emotion = emotionCtrl.text.trim();
                          final text = textCtrl.text.trim();

                          if (text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please write something.'),
                              ),
                            );
                            return;
                          }

                          if (existing == null) {
                            await _svc.addNote(
                              emotion: emotion,
                              text: text,
                              date: selectedDate,
                            );
                          } else {
                            await _svc.updateNote(
                              Note(
                                id: existing.id,
                                emotion: emotion,
                                text: text,
                                date: DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                ),
                                createdAt: existing.createdAt,
                                updatedAt: DateTime.now(),
                              ),
                            );
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.save),
                        label: Text(existing == null ? 'Save' : 'Update'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book_outlined, size: 56),
            SizedBox(height: 12),
            Text(
              'No notes yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'Start by adding your feelings and reflections.\nThis is your safe space.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
