import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';
import 'config/flavor_config.dart';
import 'data/datasources/local_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/story_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/story_provider.dart';
import 'presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.free();

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
      ],
      child: const MyApp(),
    ),
  );
}
