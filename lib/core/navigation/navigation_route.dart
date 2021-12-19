import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/view/bottom_tabbar_view.dart';

import '../constants/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;
  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings? settings) {
    // print('Generating route: ${settings?.name}');

    switch (settings?.name) {
      case NavigationConstants.HOME_VIEW:
        return pageNavigate(BottomTabbarView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Route is  not Found'),
            ),
          ),
        );
    }
  }

  MaterialPageRoute pageNavigate(Widget widget) => MaterialPageRoute(
        builder: (context) => widget,
      );
}
