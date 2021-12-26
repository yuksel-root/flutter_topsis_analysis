import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/components/text_dialog_widget.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';
import 'package:flutter_topsis_analysis/core/extension/context_extension.dart';
import 'package:flutter_topsis_analysis/viewModel/topsisProvider.dart';
import 'package:provider/provider.dart';

class DataView extends StatefulWidget {
  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late List<dynamic> rowData;
  late List<dynamic> columnData;
  TextEditingController? rowController;
  TextEditingController? columnController;

  @override
  void initState() {
    super.initState();

    this.rowData = List.of(Data.rowData);
    this.columnData = List.of(Data.columnData);
    rowController = TextEditingController();
    columnController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Veri Girişi")),
          backgroundColor: Color(0xff1c0f45),
        ),
        body: Container(
          height: context.mediaQuery.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: buildForm(),
                  width: context.mediaQuery.size.width / 1.4,
                ),
                flex: 5,
              ),
              Expanded(
                child: Container(
                  color: Color(0xff1c0f45),
                  child: Center(
                    child: Text(
                      "Karar Matrisi",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: rowData.isNotEmpty || columnData.isNotEmpty
                      ? SingleChildScrollView(
                          child: buildDataTable(),
                          scrollDirection: Axis.horizontal)
                      : Spacer(),
                ),
                flex: 10,
              )
            ],
          ),
        ),
      );

  Form buildForm() => Form(
        child: Column(
          children: [
            Flexible(
              flex: 10,
              child: TextFormField(
                controller: rowController,
                decoration: InputDecoration(
                  hintText: "Satır sayısı",
                  icon: buildContaierIconField(
                      Icons.assignment_rounded, Color(0xff551a8b)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            ),
            Spacer(), //5px
            Flexible(
              flex: 10,
              child: TextFormField(
                controller: columnController,
                decoration: InputDecoration(
                  hintText: "Sütun sayısı",
                  icon: buildContaierIconField(
                      Icons.assessment_rounded, Color(0xff1c0f45)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            ),
            Spacer(), //2px
            Expanded(
              flex: 20,
              child: Row(
                children: [
                  Expanded(child: createTableButton()),
                  Spacer(),
                  Expanded(child: calculateTablesButton()),
                ],
              ),
            )
          ],
        ),
      );

  ElevatedButton calculateTablesButton() {
    Timer _timer;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: () {
          TopsisProvider().getNormalList();
          TopsisProvider().getWeightNormalList();
          TopsisProvider().getOptimalList();
          TopsisProvider().getSiList();
          TopsisProvider().getCilist();
          _timer = new Timer(const Duration(milliseconds: 300), () {
            setState(() {
              Provider.of<TopsisProvider>(context, listen: false)
                  .navigateToResult(context);
            });
          });
        },
        child: Text("Hesapla",
            style: TextStyle(color: Colors.white, fontSize: 14)));
  }

  ElevatedButton createTableButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff1c0f45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: () {
        columnData.clear();
        rowData.clear();
        Data.columnData.clear();
        Data.rowData.clear();

        Future.delayed(Duration(milliseconds: 300), () {
          var rowCount = rowController!.text;
          var columnCount = columnController!.text;

          for (int i = 0; i < int.parse(rowCount) + 2; i++) {
            final arr = [];
            if (i == 0)
              arr.add("K.Ağırlık");
            else if (i == 1)
              arr.add("Kriter Kodu");
            else
              arr.add("row" + (i - 1).toString()); //adaylar
            for (int j = 0; j < int.parse(columnCount); j++) {
              if (i == 1)
                arr.add("k" + (j + 1).toString());
              else
                arr.add(0);
            }

            rowData.add({"row": arr, "isRow": i != 0 && i != 1});
            Data.rowData.add({"row": arr, "isRow": i != 0 && i != 1});
          }
          setState(() {
            rowData;
          });
          for (int k = 0; k < int.parse(columnCount) + 1; k++) {
            if (k == 0) {
              columnData.add("Kriter Yönü");
              Data.columnData.add("Kriter Yönü");
            } else {
              columnData.add("Fayda");
              Data.columnData.add("Fayda");
            }
          }
          setState(() {
            columnData;
          });
        });
      },
      child: Text("Tablo Oluştur",
          style: TextStyle(color: Colors.white, fontSize: 15)),
    );
  }

  Widget buildDataTable() {
    return Center(
        child: Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(20),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(120.0),
          border: TableBorder.all(
              color: Colors.black, style: BorderStyle.solid, width: 1),

          children: [getColumns(), ...getRows()], //liste kopyalama kodu
        ),
      ),
    ]));
  }

  TableRow getColumns() {
    return TableRow(
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.black, style: BorderStyle.solid, width: 1),
      ),
      children: Utils.modelBuilder(
        columnData,
        (i, column) {
          return Container(
            color: Color(0xff00b2ee),
            child: InkWell(
                customBorder: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        column.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  editColumn(column, i);
                }),
          );
        },
      ),
    );
  }

  List<TableRow> getRows() => rowData.map((row) {
        return TableRow(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 0.5),
          ),
          children: Utils.modelBuilder(row['row'], (index, cell) {
            return InkWell(
              customBorder: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.5),
              child: Ink(
                color: row['isRow'] && index != 0
                    ? Colors.white
                    : Color(0xff00b2ee),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(
                      cell is int
                          ? cell.toString()
                          : cell is double
                              ? cell.toStringAsFixed(4)
                              : cell.toString(),
                      style: row['isRow'] && index != 0
                          ? TextStyle(fontWeight: FontWeight.normal)
                          : TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
              onTap: () {
                editCell(row['row'], index);
              },
            );
          }),
        );
      }).toList();

  Future editCell(dynamic editRow, int index) async {
    final data = await showTextDialog(
      context,
      title: 'Hücre Değeri Değiştir',
      value: editRow[index].toString(),
    );
    int i = 0;
    setState(() => rowData = rowData.map((row) {
          if (row['row'] == editRow) {
            if (row['isRow']) {
              row['row'][index] = double.parse(data); //edit screen
              rowData[i]["row"][index] = double.parse(data); // edit list
            } else {
              row['row'][index] = data; //edit screen
              rowData[i]["row"][index] = data; // edit list
            }
          }
          i++;
          return row;
        }).toList());
  }

  Future editColumn(dynamic editColumn, int index) async {
    // final data = await showTextDialog(
    //   context,
    //   title: 'Sütun Değeri Değiştir',
    //   value: editColumn['Column'].toString(),
    // );
    if (index == 0) return;

    int i = 0;
    setState(() => columnData = columnData.map((column) {
          //  print({"i": i, "index": index});
          if (i == index) {
            if (column == "Fayda") {
              column = "Maliyet";
              Data.columnData[i] = "Maliyet";
            } else {
              column = "Fayda";
              Data.columnData[i] = "Fayda";
            }
          }
          i++;
          return column;
        }).toList());
    // print(columnData);
  }

  Container buildContaierIconField(IconData icon, Color iconColor) {
    return Container(
      height: context.dynamicWidth(0.05),
      width: context.dynamicWidth(0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor),
      padding: EdgeInsets.all(context.dynamicWidth(0.0025)),
    );
  }
}
