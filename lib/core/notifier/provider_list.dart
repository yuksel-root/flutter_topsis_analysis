import 'package:flutter_topsis_analysis/core/navigation/navigation_service.dart';
import 'package:flutter_topsis_analysis/core/notifier/bottom_navigation_notifier.dart';
import 'package:flutter_topsis_analysis/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_topsis_analysis/viewModel/topsisProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;
  static ApplicationProvider get instance {
    _instance ??= ApplicationProvider._init();
    return _instance!;
  }

  ApplicationProvider._init();
  List<SingleChildWidget> dependItems = [
    ChangeNotifierProvider(
      create: (context) => TopsisProvider(),
    ),
    ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
    ChangeNotifierProvider(create: (context) => TabbarNavigationProvider()),
    Provider.value(value: NavigationService.instance)
  ];
}
