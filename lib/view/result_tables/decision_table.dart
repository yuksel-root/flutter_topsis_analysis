import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/scrollable_widget.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';

class DecisionTable extends StatefulWidget {
  const DecisionTable({Key? key}) : super(key: key);

  @override
  _DecisionTableState createState() => _DecisionTableState();
}

class _DecisionTableState extends State<DecisionTable> {
  late List<dynamic> rowData;
  late List<dynamic> columnData;

  @override
  void initState() {
    super.initState();

    this.rowData = List.of(Data.rowData);
    this.columnData = List.of(Data.columnData);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    return DataTable(
      columns: getColumns(),
      rows: getRows(),
      headingRowColor: MaterialStateColor.resolveWith((states) {
        return Colors.blue;
      }),
    );
  }

  List<DataColumn> getColumns() {
    return columnData.map((dynamic column) {
      return DataColumn(
        label: InkWell(
            child: Text(
              column,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {}),
        numeric: false,
      );
    }).toList();
  }

  List<DataRow> getRows() => rowData.map((row) {
        return DataRow(
          color: MaterialStateColor.resolveWith((states) {
            return row["isRow"] ? Colors.white : Colors.blue;
          }),
          cells: Utils.modelBuilder(row['row'], (index, cell) {
            return DataCell(
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    cell is int
                        ? cell.toString()
                        : cell is double
                            ? cell.toStringAsFixed(4)
                            : cell.toString(),
                    style: row['isRow']
                        ? TextStyle(fontWeight: FontWeight.normal)
                        : TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {},
            );
          }),
        );
      }).toList();
}
