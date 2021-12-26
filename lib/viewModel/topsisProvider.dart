import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';
import 'package:flutter_topsis_analysis/core/notifier/bottom_navigation_notifier.dart';
import 'package:flutter_topsis_analysis/core/notifier/tabbar_navigation_notifier.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class TopsisProvider with ChangeNotifier {
  List<dynamic> getNormalList() {
    final row = [];
    row.add("sqrt(Eaij)");
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.kriterData.length});
    Data.NormalizationRowData.clear();
    for (int l = 1; l < Data.rowData.length; l++) {
      final arr = [];
      for (int m = 0; m < Data.columnData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      // print(arr);
      Data.NormalizationRowData.add({"row": arr, "isRow": l != 1});
    }
    //print({"normal": Data.NormalizationRowData});
    for (int i = 1; i < (Data.columnData.length); i++) {
      double n = 0;

      for (int j = 0; j < (Data.rowData.length); j++) {
        if (j == 1) continue;
        // print({
        //   "i": i,
        //   "j": j,
        //   "data": Data.rowData[j]["row"][i],
        // });

        n += Data.rowData[j]["row"][i] * Data.rowData[j]["row"][i];
      }
      // print(row);

      for (int k = 0; k < Data.NormalizationRowData.length; k++) {
        if (k == 0) continue;
        Data.NormalizationRowData[k]["row"][i] /= sqrt(n); //normalize matris
        Data.NormalizationRowData[k]["row"][i] =
            Data.NormalizationRowData[k]["row"][i];
      }
      row.add(sqrt(n)); //en alt sütun
    }
    // print({"normalDA": Data.NormalizationRowData});
    Data.NormalizationRowData.add({"row": row, "isRow": true});
    // print("aaa");
    //print(Data.NormalizationRowData);
    return Data.NormalizationRowData;
  }

  List<dynamic> getWeightNormalList() {
    // print({"length:i": Data.rowData.length});
    // print({"lrng:j", Data.columnData.length});
    Data.WeightNormalRowData.clear();

    for (int l = 0; l < 1; l++) {
      final arr = [];

      for (int m = 0; m < Data.columnData.length; m++) {
        arr.add(Data.rowData[l]["row"][m]);
      }
      // print(arr);
      Data.WeightNormalRowData.add({"row": arr, "isRow": l == 1});
    }

    for (int l = 0; l < Data.NormalizationRowData.length - 1; l++) {
      final arr = [];

      for (int m = 0; m < Data.columnData.length; m++) {
        arr.add(Data.NormalizationRowData[l]["row"][m]);
      }
      // print(arr);
      Data.WeightNormalRowData.add({"row": arr, "isRow": l != 0});
    }
    //print({"weightList": Data.WeightNormalRowData});
    for (int i = 1; i < (Data.columnData.length); i++) {
      for (int k = 1; k < Data.WeightNormalRowData.length; k++) {
        if (k == 1) continue;
        // print({
        //   "forW": Data.WeightNormalRowData[k]["row"][i],
        //   "forN": Data.NormalizationRowData[k]["row"][i],
        //   "rowData": Data.rowData[0]["row"][i],
        //   "i": i,
        //   "k": k,
        // });

        Data.WeightNormalRowData[k]["row"][i] *= Data.rowData[0]["row"][i];
        Data.WeightNormalRowData[k]["row"][i] =
            Data.WeightNormalRowData[k]["row"][i];
      }
    }

    //  print({"WD": Data.WeightNormalRowData});

    return Data.WeightNormalRowData;
  }

  List<dynamic> getOptimalList() {
    Data.OptimalRowData.clear();

    // for (int l = 0; l < 1; l++) {
    //   final arr = [];

    //   for (int m = 0; m < Data.kriterData.length; m++) {
    //     if (m == 0)
    //       arr.add("Kriter Yönü");
    //     else
    //       arr.add("Fayda");
    //   }
    //   // print(arr);
    //   Data.OptimalRowData.add({"row": arr});
    // }

    for (int l = 1; l < Data.WeightNormalRowData.length; l++) {
      final arr = [];

      for (int m = 0; m < Data.columnData.length; m++) {
        arr.add(Data.WeightNormalRowData[l]["row"][m]);
      }
      // print(arr);
      Data.OptimalRowData.add({"row": arr, "isRow": l != 1});
    }

    final arrPositive = [];
    final arrNegative = [];
    arrPositive.add("A*");
    arrNegative.add("A-");

    for (int m = 1; m < Data.columnData.length; m++) {
      double max = 0;
      double min = double.infinity;

      for (int l = 1; l < Data.OptimalRowData.length; l++) {
        // print(
        //   {
        //     "d": Data.OptimalRowData[l]["row"][m],
        //     "max": max,
        //     "min": min,
        //     "columnData": Data.columnData[m]
        //   },
        // );
        if (max < Data.OptimalRowData[l]["row"][m]) {
          max = Data.OptimalRowData[l]["row"][m];
        }
        if (min > Data.OptimalRowData[l]["row"][m]) {
          min = Data.OptimalRowData[l]["row"][m];
        }
      }
      if (Data.columnData[m] == "Fayda") {
        arrPositive.add(max);
        arrNegative.add(min);
      } else {
        arrPositive.add(min);
        arrNegative.add(max);
      }
    }
    // print("cc");
    Data.OptimalRowData.add({"row": arrPositive, "isRow": true});
    Data.OptimalRowData.add({"row": arrNegative, "isRow": true});

    return Data.OptimalRowData;
  }

  List<dynamic> getSiList() {
    Data.OptimalResultRowData.clear();

    for (int l = 1; l < Data.OptimalRowData.length - 2; l++) {
      final arr = [];
      arr.add("aday" + l.toString());
      double n = 0;
      for (int m = 1; m < Data.columnData.length; m++) {
        n += (Data.OptimalRowData[l]["row"][m] -
                Data.OptimalRowData[Data.OptimalRowData.length - 2]["row"][m]) *
            (Data.OptimalRowData[l]["row"][m] -
                Data.OptimalRowData[Data.OptimalRowData.length - 2]["row"][m]);
        // print({
        //   "pozitif": "Aday",
        //   "s1": Data.OptimalRowData[l]["row"][m],
        //   "s2": Data.OptimalRowData[Data.OptimalRowData.length - 2]["row"][m],
        //   "n": n
        // });
      }
      arr.add(sqrt(n));
      n = 0;
      for (int m = 1; m < Data.columnData.length; m++) {
        n += (Data.OptimalRowData[l]["row"][m] -
                Data.OptimalRowData[Data.OptimalRowData.length - 1]["row"][m]) *
            (Data.OptimalRowData[l]["row"][m] -
                Data.OptimalRowData[Data.OptimalRowData.length - 1]["row"][m]);
        // print({
        //   "Negatif": "Aday",
        //   "s1": Data.OptimalRowData[l]["row"][m],
        //   "s2": Data.OptimalRowData[Data.OptimalRowData.length - 1]["row"][m],
        //   "n": n
        // });
      }
      arr.add(sqrt(n));

      // print("------------------------------");

      Data.OptimalResultRowData.add({"row": arr, "isRow": true});
    }

    return Data.OptimalResultRowData;
  }

  List<dynamic> getCilist() {
    Data.ResultRowData.clear();
    final ci = [];
    for (int l = 0; l < Data.OptimalResultRowData.length; l++) {
      ci.add(Data.OptimalResultRowData[l]["row"][2] /
          (Data.OptimalResultRowData[l]["row"][2] +
              Data.OptimalResultRowData[l]["row"][1]));
    }
    // print({"cis": ci});
    final arrSort = [];

    for (int i = 0; i < Data.OptimalResultRowData.length; i++) {
      arrSort.add(1);
      for (int j = 0; j < Data.OptimalResultRowData.length; j++) {
        if (ci[i] < ci[j]) {
          arrSort[i]++;
        }
      }
    }
    // print({"arrSort": arrSort});
    for (int l = 0; l < Data.OptimalResultRowData.length; l++) {
      final arr = [];

      for (int m = 0; m < Data.OptimalResultColumnData.length; m++) {
        arr.add(Data.OptimalResultRowData[l]["row"][m]);
      }
      arr.add(ci[l]);

      arr.add(arrSort[l]);
      Data.ResultRowData.add({"row": arr, "isRow": true});
    }

    // print({
    //   "ci": Data.ResultRowData,
    //   "arrsort": arrSort,
    //   "FADDASDSADSADASD": 1 is double
    // });

    return Data.ResultRowData;
  }

  void navigateToResult(BuildContext context) {
    final bottomProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final tabbarNavProv =
        Provider.of<TabbarNavigationProvider>(context, listen: false);

    bottomProvider.currentIndex = 1;
    tabbarNavProv.currentIndex = 0;

    notifyListeners();
  }
}
