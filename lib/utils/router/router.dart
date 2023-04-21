import 'package:flutter/material.dart';
import 'package:smart_home_app/features/auth/pages/add_data_page.dart';
import 'package:smart_home_app/features/auth/pages/auth_page.dart';
import 'package:smart_home_app/features/auth/pages/forgot_password_page.dart';
import 'package:smart_home_app/features/boarding/pages/boarding_page.dart';
import 'package:smart_home_app/features/consumption/pages/new_meal_page.dart';
import 'package:smart_home_app/features/main/pages/main_page.dart';
import 'package:smart_home_app/features/auth/pages/login_or_register_page.dart';
import 'package:smart_home_app/features/notifications/pages/notifications_page.dart';
import 'package:smart_home_app/features/settings/pages/change_email_page.dart';
import 'package:smart_home_app/features/settings/pages/change_password_page.dart';
import 'package:smart_home_app/features/settings/pages/delete_account_page.dart';
import 'package:smart_home_app/utils/managers/string_manager.dart';

class Routes {
  static const String boardingRoute = '/';
  static const String mainRoute = '/main';
  static const String loginRoute = '/login';
  static const String authRoute = '/auth';
  static const String notificationsRoute = '/notifications';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String changePasswordRoute = '/changePassword';
  static const String changeEmailRoute = '/changeEmail';
  static const String deleteAccRoute = '/deleteAcc';
  static const String newMealRoute = 'newMeal';
  static const String addData = '/addData';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.boardingRoute:
        return MaterialPageRoute(builder: (_) => const BoardingPage());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.authRoute:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case Routes.notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case Routes.changePasswordRoute:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case Routes.changeEmailRoute:
        return MaterialPageRoute(builder: (_) => const ChangeEmailPage());
      case Routes.deleteAccRoute:
        return MaterialPageRoute(builder: (_) => const DeleteAccountPage());
      case Routes.newMealRoute:
        return MaterialPageRoute(builder: (_) => const NewMealPage());
      case Routes.addData:
        return MaterialPageRoute(builder: (_) => const AddDataPage());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(StringsManager.noRouteFound),
        ),
        body: const Center(
          child: Text(StringsManager.noRouteFound),
        ),
      ),
    );
  }
}
