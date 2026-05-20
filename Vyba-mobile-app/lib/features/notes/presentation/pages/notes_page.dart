import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/router/route_names.dart';
import 'package:flutter_templates/core/sync/sync_providers.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/feedback/sync_status_banner.dart';
import 'package:flutter_templates/core/widgets/layout/app_app_bar.dart';
import 'package:flutter_templates/features/notes/domain/entities/note.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_notifier.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_providers.dart';
import 'package:flutter_templates/features/notes/presentation/providers/notes_state.dart';
import 'package:go_router/go_router.dart';

/// Page displaying the list of notes with sync status.
class NotesPage extends ConsumerWidget {
  /// Creates a [NotesPage].
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesStreamProvider);

    // Listen for mutation results (create/update/delete).
    ref.listen<NotesState>(notesNotifierProvider, (_, state) {
      switch (state) {
        case NotesSuccess(:final message):
          if (message != null) {
            context.showSnackBar(message);
          }
        case NotesError(:final message):
          context.showSnackBar(message, isError: true);
        default:
          break;
      }
    });

    return Scaffold(
      appBar: AppAppBar(
        title: 'Notes',
        showBackButton: false,
        actions: [
          // Pending sync count badge.
          _SyncBadge(),
        ],
      ),
      body: Column(
        children: [
          const SyncStatusBanner(),
          Expanded(
            child: notesAsync.when(
              data: (notes) => notes.isEmpty
                  ? _EmptyState()
                  : _NotesList(notes: notes),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDetail(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openNoteDetail(BuildContext context) {
    context.goNamed(RouteNames.noteDetailName);
  }
}

class _SyncBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(pendingSyncCountProvider);
    return countAsync.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Badge(
            label: Text('$count'),
            child: IconButton(
              icon: const Icon(Icons.cloud_upload_outlined),
              onPressed: () => ref.read(syncEngineProvider).processQueue(),
              tooltip: '$count pending sync',
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 64,
            color: context.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          AppSpacing.verticalLg,
          Text(
            'No notes yet',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            'Tap + to create your first note',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.notes});
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull-to-refresh triggers server sync via the page's ProviderScope.
      },
      child: ListView.separated(
        padding: AppSpacing.paddingLg,
        itemCount: notes.length,
        separatorBuilder: (_, __) => AppSpacing.verticalSm,
        itemBuilder: (context, index) {
          final note = notes[index];
          return _NoteCard(note: note);
        },
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: note.isSynced
            ? null
            : Icon(
                Icons.cloud_upload_outlined,
                size: 18,
                color: context.colorScheme.primary.withValues(alpha: 0.6),
              ),
        onTap: () {
          context.goNamed(
            RouteNames.noteDetailName,
            extra: note.id,
          );
        },
      ),
    );
  }
}
