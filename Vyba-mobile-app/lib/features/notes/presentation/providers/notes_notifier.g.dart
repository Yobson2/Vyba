// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesNotifierHash() => r'976910ac1deb024ffe92ebc6f76b7d8f86bc9515';

/// Manages notes mutation state (create, update, delete).
///
/// Notes list is handled reactively via [notesStreamProvider].
/// This notifier handles one-shot operations and their status.
///
/// Copied from [NotesNotifier].
@ProviderFor(NotesNotifier)
final notesNotifierProvider =
    AutoDisposeNotifierProvider<NotesNotifier, NotesState>.internal(
  NotesNotifier.new,
  name: r'notesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotesNotifier = AutoDisposeNotifier<NotesState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
