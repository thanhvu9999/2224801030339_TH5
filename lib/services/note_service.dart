import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService {
  static const String _storageKey = 'notes_list';

  // Lấy danh sách ghi chú từ SharedPreferences
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString(_storageKey);
    if (notesJson == null || notesJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(notesJson) as List<dynamic>;
      return decodedList
          .map((item) => Note.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Lưu danh sách ghi chú vào SharedPreferences
  Future<void> _saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      notes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  // Thêm ghi chú mới (thêm vào đầu danh sách để ghi chú mới nhất lên trên)
  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.insert(0, note);
    await _saveNotes(notes);
  }

  // Cập nhật ghi chú đã có
  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await _saveNotes(notes);
    }
  }

  // Xóa ghi chú theo ID
  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await _saveNotes(notes);
  }
}

