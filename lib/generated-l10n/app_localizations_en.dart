// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get addStory => 'Add Story';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get noAccount => 'Don\'t have an account? Register';

  @override
  String get haveAccount => 'Already have an account? Login';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get pleaseEnterName => 'Please enter name';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get failedToLogin => 'Failed to login';

  @override
  String get failedToRegister => 'Failed to register';

  @override
  String get failedToAddStory => 'Failed to add story';

  @override
  String get successRegister => 'Registration successful! Please login.';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get noStories => 'No stories available';

  @override
  String get detailStory => 'Story Detail';

  @override
  String get createdAt => 'Created at';

  @override
  String get logoutApp => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get welcomeBack => 'Welcome back! Please login to continue.';

  @override
  String get createAccount =>
      'Create an account to start sharing your stories.';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get storyUploaded => 'Story uploaded successfully!';
}
