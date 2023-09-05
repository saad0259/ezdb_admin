import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/navigator_model.dart';
import '../../model/users_model.dart';
import '../../repo/admins_repo.dart';
import '../../state/auth_state.dart';
import '../../state/navigator_state.dart';
import '../../state/theme_state.dart';
import '../../state/user_state.dart';
import '../../util/sf_grid_helper.dart';
import 'users_list_view.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);

      AdminRepo.instance.addAdminLogs(authState.admin!.email,
          'Looked up search details for ${widget.userModel.phone}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      NavigatorModel('Users', const UsersListView()),
                    );
                    navState.active.title = 'Users';
                  },
                ),
                const SizedBox(width: 20),
                Text(
                  'User Details',
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
                uid: widget.userModel.id,
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
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final UserModel userData = userState.getUserById(uid);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SfDataGrid(
            source: DataSource(context: context, data: userData.userSearch),
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
        getGridColumn(name: 'Search Value'),
        getGridColumn(name: 'Search Type'),
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
  final List<UserSearch> data;
  List<UserSearch> availableData = [];

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

  List<DataGridCell> getCells(UserSearch model) => [
        DataGridCell<String>(
            columnName: '',
            value: DateFormat('dd-MM-yyyy hh:mma').format(model.createdAt)),
        DataGridCell<String>(columnName: '', value: model.searchValue),
        DataGridCell<String>(columnName: '', value: model.searchType),
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
    for (UserSearch model in availableData) {
      rowList.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: '', value: (counter++).toString()),
        ...getCells(model)
      ]));
    }
  }

  void _addMoreRows(List<UserSearch> newData, int count) {
    final startIndex = newData.isNotEmpty ? newData.length : 0,
        endIndex = (startIndex + count) >= data.length
            ? data.length
            : startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
      newData.add(data[i]);
    }
  }
}
