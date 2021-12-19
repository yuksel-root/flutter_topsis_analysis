import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/scrollable_widget.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/components/text_dialog_widget.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';

class EditableTable extends StatefulWidget {
  @override
  _EditableTableState createState() => _EditableTableState();
}

class _EditableTableState extends State<EditableTable> {
  late List<dynamic> rowData;
  late List<dynamic> kriterData;

  @override
  void initState() {
    super.initState();

    this.rowData = List.of(Data.rowData);
    this.kriterData = List.of(Data.kriterData);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    return DataTable(
      columns: getColumns(kriterData),
      rows: getRows(),
    );
  }

  List<DataColumn> getColumns(List<dynamic> columns) {
    return columns.map((dynamic column) {
      return DataColumn(
        label: InkWell(
            child: Text(column['Kriter']),
            onTap: () {
              print("adsdsada");
              editColumn(column);
            }),
        numeric: false,
      );
    }).toList();
  }

  List<DataRow> getRows() => rowData.map((row) {
        //rowData[0]['aday'].map((a) => cells.add(a));
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

    setState(() => rowData = rowData.map((row) {
          if (row['row'] == editRow) {
            row['row'][index] = data;
          }
          return row;
        }).toList());
  }

  Future editColumn(dynamic editColumn) async {
    final data = await showTextDialog(
      context,
      title: 'Sütun Değeri Değiştir',
      value: editColumn['Kriter'].toString(),
    );

    setState(() => kriterData = kriterData.map((column) {
          if (column == editColumn) {
            column['Kriter'] = data;
          }
          return column;
        }).toList());
  }
}
