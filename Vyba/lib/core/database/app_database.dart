import 'package:drift/drift.dart';
import 'package:flutter_templates/core/database/daos/sync_queue_dao.dart';
import 'package:flutter_templates/core/database/tables/sync_queue_table.dart';
import 'package:flutter_templates/features/notes/data/daos/notes_dao.dart';
import 'package:flutter_templates/features/notes/data/tables/notes_table.dart';

part 'app_database.g.dart';

/// Central Drift database aggregating all tables and DAOs.
@DriftDatabase(
  tables: [SyncQueueEntries, Notes],
  daos: [SyncQueueDao, NotesDao],
)
class AppDatabase extends _$AppDatabase {
  /// Creates an [AppDatabase] with the given query executor.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here.
        },
      );
}
