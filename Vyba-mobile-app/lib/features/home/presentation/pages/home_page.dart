import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/router/route_names.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/layout/app_app_bar.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:go_router/go_router.dart';

/// Home page with user greeting.
class HomePage extends ConsumerWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = switch (authState) {
      AuthAuthenticated(:final user) => user.name,
      _ => 'User',
    };

    return Scaffold(
      appBar: AppAppBar(title: context.l10n.homeTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.homeGreeting(userName),
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.verticalXl,
              Card(
                child: ListTile(
                  leading: const Icon(Icons.note_alt_outlined),
                  title: const Text('Notes'),
                  subtitle: const Text('Offline-first notes with sync'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(RouteNames.notesName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
