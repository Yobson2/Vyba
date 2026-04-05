import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_typography.dart';

/// Composes [ThemeData] from Vyba design tokens.
///
/// Dark-first nightlife app — the dark theme is the primary experience.
/// No-line rule: boundaries via tonal shifts, not borders.
class AppTheme {
  const AppTheme._();

  /// Dark theme data (primary).
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          error: AppColors.error,
          errorContainer: AppColors.errorContainer,
          surface: AppColors.surface,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onTertiary: AppColors.onTertiary,
          onError: AppColors.onError,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.inversePrimary,
          surfaceTint: AppColors.surfaceTint,
          surfaceContainerLowest: AppColors.surfaceContainerLowest,
          surfaceContainerLow: AppColors.surfaceContainerLow,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerHigh: AppColors.surfaceContainerHigh,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          surfaceBright: AppColors.surfaceBright,
          surfaceDim: AppColors.surfaceDim,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: AppTypography.darkTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.darkTextTheme.titleLarge,
        ),
        // No-line rule: inputs use surfaceContainerHighest bg, no border.
        // On focus: 2px primary bottom-border only (editorial style).
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintStyle: AppTypography.darkTextTheme.bodyMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimaryFixed,
            minimumSize: const Size(double.infinity, AppTouchTarget.button),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            textStyle: AppTypography.darkTextTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, AppTouchTarget.button),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            side: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: AppOpacity.medium),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        // No-line rule: cards have no border, use tonal layering.
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        // No-line rule: chips have no border.
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerHigh,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
          labelStyle: AppTypography.darkTextTheme.labelMedium,
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.outlineVariant.withValues(alpha: AppOpacity.medium),
          thickness: 1,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimaryFixed,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.onSurface,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          dividerColor: Colors.transparent,
          labelStyle: AppTypography.darkTextTheme.labelLarge,
          unselectedLabelStyle: AppTypography.darkTextTheme.labelMedium,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceContainerHighest,
          contentTextStyle: AppTypography.darkTextTheme.bodyMedium,
          actionTextColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          textStyle: AppTypography.darkTextTheme.bodySmall?.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withValues(alpha: AppOpacity.light),
          height: AppTouchTarget.button + 24,
          labelTextStyle: WidgetStatePropertyAll(
            AppTypography.darkTextTheme.labelSmall,
          ),
        ),
      );

  /// Light theme data.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.inversePrimary,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondaryContainer,
          secondaryContainer: AppColors.onSecondaryContainer,
          error: AppColors.errorDim,
          errorContainer: AppColors.onErrorContainer,
          surface: AppColors.inverseSurface,
          onPrimary: AppColors.onSurface,
          onSurface: AppColors.surface,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant.withValues(alpha: AppOpacity.moderate),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: AppTypography.lightTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.inverseSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.lightTextTheme.titleLarge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.inversePrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.errorDim),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.inversePrimary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, AppTouchTarget.button),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.inversePrimary,
            minimumSize: const Size(double.infinity, AppTouchTarget.button),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            ),
            side: const BorderSide(
              color: Color(0x4D494BD7),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.inversePrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.inversePrimary,
          unselectedItemColor: Color(0xFF94A3B8),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF1F5F9),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE2E8F0),
          thickness: 1,
        ),
      );
}
