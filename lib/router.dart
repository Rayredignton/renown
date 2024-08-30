import 'package:flutter/material.dart';
import 'package:renown/screens/chat_view.dart';
import 'package:renown/screens/main_view.dart';
import 'package:renown/screens/profile_view.dart';
import 'package:renown/screens/signin.dart';
import 'package:renown/screens/signup.dart';
import 'package:renown/screens/users.dart';


class AppRouter {
  static const String home = '/';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String users = '/users';
  static const String login = '/login';
  static const String signup = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case users:
        return MaterialPageRoute(builder: (_) => ChatUsersView());
      case login:
        return MaterialPageRoute(builder: (_) => SignInView());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
