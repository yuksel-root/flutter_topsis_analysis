import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/scrollable_widget.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';

typedef MyCalculator = String Function(dynamic aij, int columnIndex);

class ResultTable extends StatefulWidget {
  const ResultTable({Key? key, required this.calculate}) : super(key: key);

  @override
  _ResultTableState createState() => _ResultTableState();

  final MyCalculator calculate;
}

class _ResultTableState extends State<ResultTable> {
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
        label: InkWell(child: Text(column['Kriter']), onTap: () {}),
        numeric: false,
      );
    }).toList();
  }

  List<DataRow> getRows() => rowData.map((row) {
        return DataRow(
          cells: Utils.modelBuilder(row['row'], (index, cell) {
            return DataCell(
              Text(widget.calculate(cell, index)),
              onTap: () {},
            );
          }),
        );
      }).toList();
}
