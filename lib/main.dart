import 'package:chatbot/layout/layout.dart';
import 'package:chatbot/theme/colors.dart';
import 'package:chatbot/website/auth/login.dart';
import 'package:chatbot/website/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAShURLrBL3u0g1NEIOleANuxVPY94SK_E",
      authDomain: "chatbot-3f5a4.firebaseapp.com",
      projectId: "chatbot-3f5a4",
      storageBucket: "chatbot-3f5a4.firebasestorage.app",
      messagingSenderId: "702482931686",
      appId: "1:702482931686:web:8a5153c4cd06ae9dfc0027",
      measurementId: "G-JP210JX66X",
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final location = state.uri.toString();

    if (!isLoggedIn && location.startsWith('/home')) {
      return '/login';
    }

    if (isLoggedIn && (location == '/login' || location == '/signup')) {
      return '/home/user';
    }

    return null; // No redirect
  },
  routes: [
    GoRoute(
      path: "/login",
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: "/signup",
      builder:
          (BuildContext context, GoRouterState state) => const SignupPage(),
    ),
    GoRoute(
      path: "/home/user",
      builder: (BuildContext context, GoRouterState state) => CustomLayout(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp.router(
          routerConfig: _router,
          title: "ChatBot",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.background,
          ),
        );
      },
    );
  }
}
