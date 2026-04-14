import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/story_detail_page.dart';
import '../../presentation/pages/add_story_page.dart';
import '../../presentation/pages/pick_location_page.dart';
import '../../presentation/providers/auth_provider.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authProvider.state == AuthState.authenticated;
      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/';

      if (authProvider.state == AuthState.initial && isSplash) {
        return null;
      }

      if (!isAuthenticated && !isAuthPage && !isSplash) {
        return '/login';
      }

      if (isAuthenticated && (isAuthPage || isSplash)) {
        return '/home';
      }

      if (!isAuthenticated &&
          isSplash &&
          authProvider.state != AuthState.initial) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/story/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StoryDetailPage(storyId: id);
        },
      ),
      GoRoute(
        path: '/add-story',
        builder: (context, state) => const AddStoryPage(),
      ),
      GoRoute(
        path: '/pick-location',
        builder: (context, state) => const PickLocationPage(),
      ),
    ],
  );
}
