import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:submission_pertama/generated-l10n/app_localizations.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/story_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/story_provider.dart';
import 'presentation/providers/story_list_provider.dart';

import 'package:submission_pertama/presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();
  final localDatasource = LocalDatasource(secureStorage);
  final authRepository = AuthRepository();
  final storyRepository = StoryRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository, localDatasource),
        ),
        ChangeNotifierProvider(create: (_) => StoryProvider(storyRepository)),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProxyProvider<AuthProvider, StoryListProvider>(
          create: (context) => StoryListProvider(
            StoryRepository(),
            context.read<AuthProvider>().token ?? '',
          ),
          update: (context, auth, previous) {
            if (previous == null || previous.token != auth.token) {
              return StoryListProvider(StoryRepository(), auth.token ?? '');
            }
            return previous;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _appRouter = AppRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'Story App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.router,
      locale: localeProvider.locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
    );
  }
}
