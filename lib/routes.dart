import 'package:flutter/material.dart';
import 'package:myapp/screens/home_screen.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'utils/common_widgets/invalid_route.dart';
import 'values/app_routes.dart';

class Routes {
  const Routes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case AppRoutes.login:
        return getRoute(widget: const LoginPage());

      case AppRoutes.register:
        return getRoute(widget: const RegisterPage());

      case AppRoutes.homepage:
        // Periksa apakah UID dikirim sebagai argumen
        final uid = settings.arguments as String? ?? '';
        if (uid.isEmpty) {
          return getRoute(widget: const InvalidRoute());
        }
        // Kirim UID ke `HomePage`
        return getRoute(widget: HomePage(uid: uid));

      /// Jika rute tidak valid
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
