import 'package:fluent_ui/fluent_ui.dart';

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }
}