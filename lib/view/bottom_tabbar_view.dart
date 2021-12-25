import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/core/constants/navigation_constants.dart';
import 'package:flutter_topsis_analysis/core/navigation/navigation_service.dart';
import 'package:flutter_topsis_analysis/core/notifier/bottom_navigation_notifier.dart';
import 'package:flutter_topsis_analysis/core/notifier/tabbar_navigation_notifier.dart';

import 'package:flutter_topsis_analysis/view/tabbar_view.dart';
import 'package:flutter_topsis_analysis/view/data_view.dart';
import 'package:flutter_topsis_analysis/viewModel/topsisProvider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BottomTabbarView extends StatefulWidget {
  const BottomTabbarView({Key? key}) : super(key: key);

  @override
  _BottomTabbarViewState createState() => _BottomTabbarViewState();
}

final NavigationService navigation = NavigationService.instance;
void _navigateHome(context) =>
    navigation.navigateToPageClear(path: NavigationConstants.HOME_VIEW);

class _BottomTabbarViewState extends State<BottomTabbarView> {
  @override
  void initState() {
    super.initState();
  }

  static List<Widget> currentScreen = [
    DataView(),
    TabbarView(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavigationProvider>(context);
    final tabbarProvider = Provider.of<TabbarNavigationProvider>(context);
    return Scaffold(
      body: currentScreen[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff1c0f45),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
          if (index == 0) {
            tabbarProvider.currentIndex = 0;
            _navigateHome(context);
          } else {
            TopsisProvider().getNormalList();
            TopsisProvider().getWeightNormalList();
            TopsisProvider().getOptimalList();
            TopsisProvider().getSiList();
            TopsisProvider().getCilist();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.home,
            ),
            label: "Veriler",
          ),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.globe), label: "Sonuçlar"),
        ],
      ),
    );
  }
}
