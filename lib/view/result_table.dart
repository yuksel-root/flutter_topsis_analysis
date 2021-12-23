import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/scrollable_widget.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';

class ResultTable extends StatefulWidget {
  final rowData;
  final kriterData;
  const ResultTable({Key? key, required this.rowData, required this.kriterData})
      : super(key: key);

  @override
  _ResultTableState createState() => _ResultTableState();
}

class _ResultTableState extends State<ResultTable> {
  late List<dynamic> rowData;
  late List<dynamic> kriterData;

  @override
  void initState() {
    super.initState();

    this.rowData = List.of(widget.rowData);
    this.kriterData = List.of(widget.kriterData);
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
              Text(cell is int
                  ? cell.toString()
                  : cell is double
                      ? cell.toStringAsFixed(4)
                      : cell.toString()),
              onTap: () {},
            );
          }),
        );
      }).toList();
}
