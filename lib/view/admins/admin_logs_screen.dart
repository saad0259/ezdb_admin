import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../flutter-utils/snippets/shimmers_effects.dart';
import '../../model/admin_model.dart';
import '../../model/navigator_model.dart';
import '../../state/admin_state.dart';
import '../../state/navigator_state.dart';
import '../../state/theme_state.dart';
import '../../util/sf_grid_helper.dart';
import 'admin_list_screen.dart';

class AdminLogsView extends StatefulWidget {
  const AdminLogsView({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<AdminLogsView> createState() => _AdminLogsViewState();
}

class _AdminLogsViewState extends State<AdminLogsView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final AdminState adminState =
          Provider.of<AdminState>(context, listen: false);
      await adminState.loadLogs(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AdminState adminState = Provider.of<AdminState>(context);
    return adminState.isLoading
        ? shimmerTableEffect()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: context.read<ThemeState>().darkTheme
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          final NavState navState =
                              Provider.of<NavState>(context, listen: false);
                          navState.activate(
                            NavigatorModel('Admins', const AdminListScreen()),
                          );
                          navState.active.title = 'Admins';
                        },
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Admin Logs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.read<ThemeState>().darkTheme
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: UserSearchListView(
                      uid: widget.uid,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class UserSearchListView extends StatelessWidget {
  UserSearchListView({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    final AdminState adminState =
        Provider.of<AdminState>(context, listen: false);
    final List<AdminLogs> logsData = adminState.logs.reversed.toList();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SfDataGrid(
            source: DataSource(context: context, data: logsData),
            columns: <GridColumn>[
              getGridColumn(name: '#', width: ColumnWidthMode.fitByCellValue),
              ...getColumns(),
            ],
            loadMoreViewBuilder: loadMoreViewBuilderWidget,
          ),
        ),
      ),
    );
  }

  GridColumn getGridColumn({
    required String name,
    ColumnWidthMode width = ColumnWidthMode.fill,
    Alignment align = Alignment.center,
  }) {
    return GridColumn(
      columnWidthMode: width,
      columnName: name,
      label: Align(
        alignment: align,
        child: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<GridColumn> getColumns() => [
        getGridColumn(name: 'Created At'),
        getGridColumn(name: 'Action'),
      ];
}

class DataSource extends DataGridSource {
  DataSource({
    required this.context,
    required this.data,
  }) {
    availableData = data.sublist(0, 21 > data.length ? data.length : 21);
    buildDataGridRows();
  }
  final BuildContext context;
  final List<AdminLogs> data;
  List<AdminLogs> availableData = [];

  List<DataGridRow> rowList = [];
  @override
  List<DataGridRow> get rows => rowList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Align(
          alignment: dataGridCell.columnName == "action"
              ? Alignment.centerRight
              : Alignment.center,
          child: dataGridCell.value is Widget
              ? dataGridCell.value
              : Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }

  List<DataGridCell> getCells(AdminLogs model) => [
        DataGridCell<String>(
            columnName: '',
            value: DateFormat('dd-MM-yyyy hh:mma').format(model.createdAt)),
        DataGridCell<String>(columnName: '', value: model.contents),
      ];

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 1));

    _addMoreRows(availableData, 15);
    buildDataGridRows();
    notifyListeners();
  }

  void buildDataGridRows() {
    int counter = 1;
    rowList.clear();
    for (AdminLogs model in availableData) {
      rowList.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: '', value: (counter++).toString()),
        ...getCells(model)
      ]));
    }
  }

  void _addMoreRows(List<AdminLogs> newData, int count) {
    final startIndex = newData.isNotEmpty ? newData.length : 0,
        endIndex = (startIndex + count) >= data.length
            ? data.length
            : startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
      newData.add(data[i]);
    }
  }
}
