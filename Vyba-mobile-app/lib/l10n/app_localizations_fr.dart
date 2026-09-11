// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vyba';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonNoResults => 'Aucun résultat trouvé';

  @override
  String get commonSeeAll => 'Voir tout';

  @override
  String get commonOr => 'Ou';

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Pas de connexion Internet. Vérifiez votre réseau.';

  @override
  String get errorServer => 'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get errorUnauthorized => 'Session expirée. Veuillez vous reconnecter.';

  @override
  String get errorValidation =>
      'Veuillez vérifier vos informations et réessayer.';

  @override
  String get errorTimeout => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authRegister => 'S\'inscrire';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authName => 'Nom complet';

  @override
  String get authLoginSubtitle => 'Bon retour ! Connectez-vous pour continuer.';

  @override
  String get authRegisterSubtitle => 'Créez un compte pour commencer.';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre e-mail et nous vous enverrons un code pour réinitialiser votre mot de passe.';

  @override
  String get authNoAccount => 'Pas encore de compte ? ';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get authOtpTitle => 'Vérifiez votre e-mail';

  @override
  String authOtpSubtitle(String email) {
    return 'Entrez le code à 6 chiffres envoyé à $email';
  }

  @override
  String get authOtpResend => 'Vous n\'avez pas reçu le code ? Renvoyer';

  @override
  String get authLoginWithGoogle => 'Continuer avec Google';

  @override
  String get authLoginWithApple => 'Continuer avec Apple';

  @override
  String get authTerms =>
      'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.';

  @override
  String get validationRequired => 'Ce champ est requis';

  @override
  String get validationEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get validationPasswordLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get validationPasswordMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get onboardingTitle1 => 'Bienvenue';

  @override
  String get onboardingDesc1 =>
      'Découvrez une nouvelle façon de gérer vos tâches et booster votre productivité.';

  @override
  String get onboardingTitle2 => 'Restez organisé';

  @override
  String get onboardingDesc2 =>
      'Gardez tout au même endroit avec notre interface intuitive.';

  @override
  String get onboardingTitle3 => 'Commencez';

  @override
  String get onboardingDesc3 =>
      'Créez votre compte et commencez votre aventure aujourd\'hui.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get homeTitle => 'Accueil';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEn => 'Anglais';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsAbout => 'À propos';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get offlineBanner => 'Vous êtes hors ligne';

  @override
  String get emptyStateTitle => 'Rien ici pour le moment';

  @override
  String get emptyStateSubtitle => 'Revenez plus tard pour les mises à jour.';
}
