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
                rowData: getDecisionList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getWeightNormalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getOptimalList(),
                kriterData: Data.kriterData,
              ),
              ResultTable(
                rowData: getSiList(),
                kriterData: [
                  {"Kriter": ""},
                  {"Kriter": "Si*"},
                  {"Kriter": "Si-"}
                ],
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

  List<dynamic> getDecisionList() {
    return Data.rowData;
  }

  List<dynamic> getNormalList() {
    final row = [];
    row.add("sqrt(Eaij)");
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.kriterData.length});
    Data.NormalizationListData.clear();
    for (int l = 1; l < Data.rowData.length; l++) {
      final arr = [];
      for (int m = 0; m < Data.kriterData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      //print(arr);
      Data.NormalizationListData.add({"row": arr});
    }
    // print({"normal": Data.NormalizationListData});
    for (int i = 1; i < (Data.kriterData.length); i++) {
      double n = 0;

      for (int j = 0; j < (Data.rowData.length); j++) {
        // print({
        //   "i": i,
        //   "j": j,
        //   "data": Data.rowData[j]["row"][i],
        // });

        n += Data.rowData[j]["row"][i] * Data.rowData[j]["row"][i];
      }
      // print(row);
      for (int k = 0; k < Data.NormalizationListData.length; k++) {
        Data.NormalizationListData[k]["row"][i] /= sqrt(n); //normalize matris
        Data.NormalizationListData[k]["row"][i] =
            Data.NormalizationListData[k]["row"][i].toStringAsFixed(3);
      }

      row.add(sqrt(n).toStringAsFixed(3)); //en alt sütun

    }

    Data.NormalizationListData.add({"row": row});
    // print(Data.NormalizationData);
    return Data.NormalizationListData;
  }

  List<dynamic> getWeightNormalList() {
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.kriterData.length});
    Data.WeightListData.clear();

    for (int l = 0; l < 1; l++) {
      final arr = [];

      for (int m = 0; m < Data.kriterData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      // print(arr);
      Data.WeightListData.add({"row": arr});
    }

    for (int l = 0; l < Data.NormalizationListData.length - 1; l++) {
      final arr = [];

      for (int m = 0; m < Data.kriterData.length; m++) {
        if (m == 0) {
          arr.add(Data.NormalizationListData[l]["row"][m]);
        } else {
          arr.add(double.parse(Data.NormalizationListData[l]["row"][m]));
        }
      }
      // print(arr);
      Data.WeightListData.add({"row": arr});
    }
    // print({"weightList": Data.WeightListData});
    for (int i = 1; i < (Data.kriterData.length); i++) {
      for (int k = 1; k < Data.WeightListData.length; k++) {
        // print({
        //   "forW": Data.WeightListData[k]["row"][i],
        //   "forN": Data.NormalizationListData[k]["row"][i],
        //   "i": i,
        //   "k": k,
        // });

        Data.WeightListData[k]["row"][i] *= Data.rowData[0]["row"][i];
        Data.WeightListData[k]["row"][i] =
            Data.WeightListData[k]["row"][i].toStringAsFixed(4);
      }
    }

    //Data.WeightListData.add({"row": row});
    // print({"WD": Data.WeightListData});

    return Data.WeightListData;
  }

  List<dynamic> getOptimalList() {
    Data.OptimalListData.clear();

    for (int l = 0; l < 1; l++) {
      final arr = [];

      for (int m = 0; m < Data.kriterData.length; m++) {
        if (m == 0)
          arr.add("Kriter Yönü");
        else
          arr.add("Fayda");
      }
      // print(arr);
      Data.OptimalListData.add({"row": arr});
    }

    for (int l = 1; l < Data.WeightListData.length; l++) {
      final arr = [];

      for (int m = 0; m < Data.kriterData.length; m++) {
        if (m == 0) {
          arr.add(Data.WeightListData[l]["row"][m]);
        } else {
          arr.add(double.parse(Data.WeightListData[l]["row"][m]));
        }
      }
      // print(arr);
      Data.OptimalListData.add({"row": arr});
    }

    final arrMax = [];
    final arrMin = [];
    arrMax.add("A*");
    arrMin.add("A-");

    for (int m = 1; m < Data.kriterData.length; m++) {
      double max = 0;
      double min = 9999;

      for (int l = 1; l < Data.OptimalListData.length; l++) {
        // print(
        //   {
        //     "d": Data.OptimalListData[l]["row"][m] is double,
        //     "max": max,
        //     "min": min,
        //   },
        // );
        if (max < Data.OptimalListData[l]["row"][m]) {
          max = Data.OptimalListData[l]["row"][m];
        }
        if (min > Data.OptimalListData[l]["row"][m]) {
          min = Data.OptimalListData[l]["row"][m];
        }
      }
      arrMax.add(max);
      arrMin.add(min);
    }
    // print("cc");
    Data.OptimalListData.add({"row": arrMax});
    Data.OptimalListData.add({"row": arrMin});

    return Data.OptimalListData;
  }

  List<dynamic> getSiList() {
    Data.SiListData.clear();

    for (int l = 1; l < Data.OptimalListData.length - 2; l++) {
      final arr = [];
      arr.add("aday" + l.toString());
      double n = 0;
      for (int m = 1; m < Data.kriterData.length; m++) {
        n += (Data.OptimalListData[l]["row"][m] -
                Data.OptimalListData[Data.OptimalListData.length - 2]["row"]
                    [m]) *
            (Data.OptimalListData[l]["row"][m] -
                Data.OptimalListData[Data.OptimalListData.length - 2]["row"]
                    [m]);
        // print({
        //   "pozitif": "Aday",
        //   "s1": Data.OptimalListData[l]["row"][m],
        //   "s2": Data.OptimalListData[Data.OptimalListData.length - 2]["row"][m],
        //   "n": n
        // });
      }
      arr.add(sqrt(n));
      n = 0;
      for (int m = 1; m < Data.kriterData.length; m++) {
        n += (Data.OptimalListData[l]["row"][m] -
                Data.OptimalListData[Data.OptimalListData.length - 1]["row"]
                    [m]) *
            (Data.OptimalListData[l]["row"][m] -
                Data.OptimalListData[Data.OptimalListData.length - 1]["row"]
                    [m]);
        // print({
        //   "Negatif": "Aday",
        //   "s1": Data.OptimalListData[l]["row"][m],
        //   "s2": Data.OptimalListData[Data.OptimalListData.length - 1]["row"][m],
        //   "n": n
        // });
      }
      arr.add(sqrt(n));

      // print("------------------------------");

      Data.SiListData.add({"row": arr});
    }

    return Data.SiListData;
  }
}
