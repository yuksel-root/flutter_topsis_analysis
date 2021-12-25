import 'package:flutter/material.dart';
import 'package:flutter_topsis_analysis/components/scrollable_widget.dart';
import 'package:flutter_topsis_analysis/components/utils.dart';
import 'package:flutter_topsis_analysis/core/constants/data.dart';

class WeightNormalTable extends StatefulWidget {
  const WeightNormalTable({
    Key? key,
  }) : super(key: key);

  @override
  _WeightNormalTableState createState() => _WeightNormalTableState();
}

class _WeightNormalTableState extends State<WeightNormalTable> {
  late List<dynamic> rowData;
  late List<dynamic> columnData;

  @override
  void initState() {
    super.initState();
    print("Weight Table is On");
    this.rowData = List.of(Data.WeightNormalRowData);
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