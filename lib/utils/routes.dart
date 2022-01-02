import 'package:flutter/material.dart';
import 'package:simple_mvvm_app/src/view/screens/home_page.dart';
import 'package:simple_mvvm_app/src/view/screens/phone_verification_page.dart';
import 'package:simple_mvvm_app/src/view/screens/signin_page.dart';
class AppRoute {
  static Route generateRoute(RouteSettings settings) {

    if (settings.name == LoginPage.routeName) {
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    } else if (settings.name == HomePage.routeName) {
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
    } else if (settings.name == PhoneVerification.routeName) {
      final Map<String, dynamic> userInfo = settings.arguments as Map<String, dynamic> ;
      return MaterialPageRoute(
        builder: (context) =>  PhoneVerification(userInfo),
      );
    }
    return MaterialPageRoute(
      builder: (context) =>  const Center(
        child: Text("Unknown page"),
      ),
    );
  }
}