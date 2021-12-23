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
            children: [
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
            ],
          ),
        );
      }),
    );
  }

  List<dynamic> getNormalList() {
    final row = [];
    row.add("sqrt(Eaij)");
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.kriterData.length});
    final List<dynamic> newRowData = [];

    for (int l = 1; l < Data.rowData.length; l++) {
      final arr = [];
      for (int m = 0; m < Data.kriterData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      //print(arr);
      newRowData.add({"row": arr});
    }

    for (int i = 1; i < (Data.kriterData.length); i++) {
      double n = 0;

      for (int j = 1; j < (Data.rowData.length); j++) {
        // print({
        //   "i": i,
        //   "j": j,
        //   "data": Data.rowData[j]["row"][i],
        // });

        n += Data.rowData[j]["row"][i] * Data.rowData[j]["row"][i];
      }
      // print(row);
      for (int k = 0; k < newRowData.length; k++) {
        newRowData[k]["row"][i] /= sqrt(n); //normalize matris
        newRowData[k]["row"][i] = newRowData[k]["row"][i].toStringAsFixed(3);
      }

      row.add(sqrt(n).toStringAsFixed(3)); //en alt sütun

    }

    newRowData.add({"row": row});
    // print(newRowData);
    return newRowData;
  }

  List<dynamic> getWeightNormalList() {
    final row = [];
    row.add("sqrt(Eaij)");
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.kriterData.length});
    final List<dynamic> newRowData = [];

    for (int l = 0; l < Data.rowData.length; l++) {
      final arr = [];
      for (int m = 0; m < Data.kriterData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      // print(arr);
      newRowData.add({"row": arr});
    }

    for (int i = 1; i < (Data.kriterData.length); i++) {
      double n = 0;

      for (int j = 0; j < (Data.rowData.length); j++) {
        n += Data.rowData[j]["row"][i] * Data.rowData[j]["row"][i];
      }
      for (int k = 0; k < Data.rowData.length; k++) {
        newRowData[k]["row"][i] /= sqrt(n);
        newRowData[k]["row"][i] = newRowData[k]["row"][i].toStringAsFixed(3);
      }
      row.add(sqrt(n).toStringAsFixed(3));
    }

    newRowData.add({"row": row});

    return newRowData;
  }
}
