import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';
import 'package:flutter_topsis_analysis/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_topsis_analysis/view/result_table.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class TabbarView extends StatefulWidget {
  TabbarView({Key? key}) : super(key: key);

  @override
  _TabbarViewState createState() => _TabbarViewState();
}

class _TabbarViewState extends State<TabbarView> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabbarNavProv = Provider.of<TabbarNavigationProvider>(context);

    return DefaultTabController(
      length: 6,
      initialIndex: tabbarNavProv.currentIndex,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            tabbarNavProv.currentIndex = tabController.index;
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text('Topsis App')),
            bottom: TabBar(
                indicatorColor: Colors.greenAccent,
                isScrollable: true,
                tabs: [
                  Tab(text: "Karar Matrisi"),
                  Tab(text: "Normalize Matrisi"),
                  Tab(text: "Ağırlıklı Normalize"),
                  Tab(text: "İdealler"),
                  Tab(text: "Si Tablo"),
                  Tab(text: "C* Tablo")
                ]),
          ),
          body: TabBarView(
            children: List<Widget>.generate(
              6,
              (index) => ResultTable(
                calculate: Normalization,
              ),
            ),
          ),
        );
      }),
    );
  }

  String Normalization(dynamic aij, int columnIndex) {
    double payda = 0;

    if (columnIndex == 0) return aij.toString();

    for (int i = 0; i < Data.rowData.length; i++) {
      payda += Data.rowData[i]["row"][columnIndex] *
          Data.rowData[i]["row"][columnIndex];
    }

    return (aij / sqrt(payda)).toString();
  }
}
