import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/extensions/context_extensions.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/utils/validators.dart';
import 'package:flutter_templates/core/widgets/buttons/app_primary_button.dart';
import 'package:flutter_templates/core/widgets/inputs/app_password_field.dart';
import 'package:flutter_templates/core/widgets/inputs/app_text_field.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_templates/features/auth/presentation/widgets/auth_header.dart';
import 'package:go_router/go_router.dart';

/// Registration page with name, email, password form.
class RegisterPage extends ConsumerStatefulWidget {
  /// Creates a [RegisterPage].
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.unfocus();
      ref.read(authNotifierProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        context.showSnackBar(state.message, isError: true);
      }
      if (state is AuthAuthenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  title: context.l10n.authRegister,
                  subtitle: context.l10n.authRegisterSubtitle,
                ),
                AppTextField(
                  controller: _nameController,
                  label: context.l10n.authName,
                  hint: 'John Doe',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) => Validators.required(v, fieldName: 'Name'),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                AppSpacing.verticalLg,
                AppTextField(
                  controller: _emailController,
                  label: context.l10n.authEmail,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                AppSpacing.verticalLg,
                AppPasswordField(
                  controller: _passwordController,
                  label: context.l10n.authPassword,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.verticalLg,
                AppPasswordField(
                  controller: _confirmPasswordController,
                  label: context.l10n.authConfirmPassword,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onRegister(),
                ),
                AppSpacing.verticalXl,
                AppPrimaryButton(
                  text: context.l10n.authRegister,
                  onPressed: _onRegister,
                  isLoading: isLoading,
                ),
                AppSpacing.verticalLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.l10n.authHaveAccount),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(context.l10n.authLogin),
                    ),
                  ],
                ),
                AppSpacing.verticalXl,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
