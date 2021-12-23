import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/components/text_dialog_widget.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';
import 'package:flutter_topsis_analysis/core/extension/context_extension.dart';

class DataView extends StatefulWidget {
  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late List<dynamic> rowData;
  late List<dynamic> kriterData;
  TextEditingController? rowController;
  TextEditingController? columnController;

  @override
  void initState() {
    super.initState();

    this.rowData = List.of(Data.rowData);
    this.kriterData = List.of(Data.kriterData);
    rowController = TextEditingController();
    columnController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Center(child: Text("Veri Girişi"))),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: rowData.isNotEmpty || kriterData.isNotEmpty
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
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Hesapla",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14)))),
                ],
              ),
            )
          ],
        ),
      );

  ElevatedButton createTableButton() {
    return ElevatedButton(
      onPressed: () {
        kriterData.clear();
        rowData.clear();
        Data.kriterData.clear();
        Data.rowData.clear();

        final rowCount = rowController!.text;
        final columnCount = columnController!.text;

        for (int i = 0; i < int.parse(rowCount); i++) {
          final arr = [];
          arr.add("aday" + (i + 1).toString());
          for (int j = 0; j < int.parse(columnCount); j++) {
            arr.add(0);
          }

          rowData.add({"row": arr});
          Data.rowData.add({"row": arr});
        }
        setState(() {
          rowData;
        });
        for (int k = 0; k < int.parse(columnCount) + 1; k++) {
          kriterData.add({"Kriter": "k" + k.toString()});
          Data.kriterData.add({"Kriter": "k" + k.toString()});
        }
        setState(() {
          kriterData;
        });
      },
      child: Text("Tablo Oluştur",
          style: TextStyle(color: Colors.white, fontSize: 15)),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff1c0f45))),
    );
  }

  Widget buildDataTable() {
    return DataTable(
      columns: getColumns(kriterData),
      rows: getRows(),
    );
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

  List<DataColumn> getColumns(List<dynamic> columns) {
    return columns.map((dynamic column) {
      return DataColumn(
        label: InkWell(
            child: Text(column['Kriter']),
            onTap: () {
              editColumn(column);
            }),
        numeric: false,
      );
    }).toList();
  }

  List<DataRow> getRows() => rowData.map((row) {
        return DataRow(
          cells: Utils.modelBuilder(row['row'], (index, cell) {
            return DataCell(
              Text(cell.toString()),
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
            row['row'][index] = data; //edit screen
            rowData[i]["row"][index] = data; // edit list
          }
          i++;
          return row;
        }).toList());
  }

  Future editColumn(dynamic editColumn) async {
    final data = await showTextDialog(
      context,
      title: 'Sütun Değeri Değiştir',
      value: editColumn['Kriter'].toString(),
    );
    int i = 0;
    setState(() => kriterData = kriterData.map((column) {
          if (column == editColumn) {
            column['Kriter'] = data;
            kriterData[i]["Kriter"] = data;
          }
          i++;
          return column;
        }).toList());
  }
}
