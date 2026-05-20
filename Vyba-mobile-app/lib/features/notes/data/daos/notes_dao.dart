import 'package:drift/drift.dart';
import 'package:flutter_templates/core/database/app_database.dart';
import 'package:flutter_templates/features/notes/data/tables/notes_table.dart';

part 'notes_dao.g.dart';

/// DAO for notes table operations.
@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  /// Creates a [NotesDao].
  NotesDao(super.db);

  /// Watches all notes ordered by updatedAt descending.
  Stream<List<Note>> watchAll() {
    return (select(notes)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Gets all notes.
  Future<List<Note>> getAll() {
    return (select(notes)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// Gets a single note by local ID.
  Future<Note?> getById(String id) {
    return (select(notes)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Inserts or replaces a note.
  Future<void> upsert(NotesCompanion entry) {
    return into(notes).insertOnConflictUpdate(entry);
  }

  /// Deletes a note by ID.
  Future<void> deleteById(String id) {
    return (delete(notes)..where((t) => t.id.equals(id))).go();
  }

  /// Marks a note as synced.
  Future<void> markSynced(String id, {String? serverId}) {
    return (update(notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(
        isSynced: const Value(true),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
      ),
    );
  }

  /// Replaces all notes from a server response (for full refresh).
  Future<void> replaceAll(List<NotesCompanion> serverNotes) {
    return transaction(() async {
      await delete(notes).go();
      await batch((b) => b.insertAll(notes, serverNotes));
    });
  }
}
