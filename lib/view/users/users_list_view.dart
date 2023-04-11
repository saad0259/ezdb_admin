import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart';

import '../../model/navigator_model.dart';
import '../../model/users_model.dart';
import '../../repo/auth_repo.dart';
import '../../state/navigator_state.dart';
import '../../state/user_state.dart';
import '../../util/sf_grid_helper.dart';
import '../../util/snippet.dart';
import '../../view/responsive/extended_media_query.dart';
import 'user_view.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    if (userState.userList.isEmpty) {
      userState.isLoading = true;
      await userState.loadUserdata();
      userState.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    return userState.isLoading
        ? shimmerTableEffect()
        : Padding(
            padding: const EdgeInsets.all(32.0),
            child: GetSFTableCard(
              data: userState.filteredUsers,
            ),
          );
  }
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
  final List<UserModel> data;
  List<UserModel> availableData = [];

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

  List<DataGridCell> getCells(UserModel model) => [
        DataGridCell<String>(
            columnName: '',
            value: DateFormat('MMM-dd-yy hh:mma').format(model.createdAt)),
        DataGridCell<String>(columnName: '', value: model.name),
        DataGridCell<String>(columnName: '', value: model.phone),
        DataGridCell<String>(columnName: '', value: model.email),
      ];

  List<Widget> getActions(BuildContext context, UserModel model) => [
        Flexible(
          child: Tooltip(
            message: model.isBlocked ? 'Unblock User' : 'Block User',
            child: Switch(
              value: model.isBlocked,
              onChanged: (value) async {
                getStickyLoader(context);
                try {
                  await AuthRepo.instance.updateBlockStatus(model.id, value);
                  snack(context, value ? 'User Blocked' : 'User Unblocked',
                      info: true);
                } catch (e) {
                  log(e.toString());
                  snack(context, 'Error updating block status');
                }
                pop(context);
              },
              activeTrackColor: Colors.redAccent,
              activeColor: Colors.white,
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.upgrade, color: Colors.grey, size: 20),
            tooltip: 'Upgrade Membership',
            onPressed: () async {
              final int remainingDays =
                  model.memberShipExpiry.difference(DateTime.now()).inDays + 1;
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Upgrade Membership'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        remainingDays < 0
                            ? 'Membership expired'
                            : 'Remaining days in expiry: $remainingDays',
                      ),
                      SizedBox(height: 16),

                      //button to pick date
                      Consumer<UserState>(
                        builder: (context, userState, child) {
                          return TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              );
                              if (picked != null) {
                                userState.selectedDate = picked;
                              }
                            },
                            child: Text(
                              userState.selectedDate == null
                                  ? 'Pick Date'
                                  : DateFormat('MMM-dd-yy')
                                      .format(userState.selectedDate!),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () async {
                          final UserState userState =
                              Provider.of<UserState>(context, listen: false);

                          final DateTime? newExpiry = userState.selectedDate;
                          if (newExpiry == null) {
                            snack(context, 'Please pick a date');
                            return;
                          }
                          getStickyLoader(context);

                          try {
                            getStickyLoader(context);

                            await AuthRepo.instance.updateMembershipExpiryDate(
                                model.id, newExpiry);

                            snack(context, 'Membership upgraded', info: true);
                            pop(context);
                            pop(context);
                          } catch (e) {
                            log(e.toString());
                            snack(context, 'Error upgrading membership');
                          }
                          userState.selectedDate = null;

                          pop(context);
                        },
                        child: Text('Upgrade'),
                      ),
                    ],
                  ),
                ),
              );
            },
            padding: EdgeInsets.zero,
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.visibility, color: Colors.grey, size: 20),
            tooltip: 'View User',
            onPressed: () async {
              final NavState navState =
                  Provider.of<NavState>(context, listen: false);
              navState.activate(
                NavigatorModel('Users', UserView(uid: model.id)),
              );
            },
            padding: EdgeInsets.zero,
          ),
        ),
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
    for (UserModel model in availableData) {
      rowList.add(DataGridRow(cells: [
        DataGridCell<String>(columnName: '', value: (counter++).toString()),
        ...getCells(model),
        DataGridCell<Widget>(
          columnName: '',
          value: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: getActions(context, model)),
        ),
      ]));
    }
  }

  void _addMoreRows(List<UserModel> newData, int count) {
    final startIndex = newData.isNotEmpty ? newData.length : 0,
        endIndex = (startIndex + count) >= data.length
            ? data.length
            : startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
      newData.add(data[i]);
    }
  }
}

Future<void> buildPdf(BuildContext context, List<UserModel> dataList) async {
  try {
    if (dataList.isEmpty) {
      throw 'No data found';
    }
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
    final PdfGrid grid = PdfGrid();
// Specify the grid column count.
    grid.columns.add(count: 4);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Name';
    headerRow.cells[1].value = 'Phone';
    headerRow.cells[2].value = 'Email';
    // headerRow.cells[3].value = 'Verified';
    // headerRow.cells[4].value = 'Days Left';
    headerRow.cells[3].value = 'Date';
// Set header font.
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid.

    for (UserModel item in dataList) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = item.name;
      row.cells[1].value = item.phone;
      row.cells[2].value = item.email;
      // row.cells[3].value = item.isVerified ? 'Yes' : 'No';
      // row.cells[4].value = item.remainingDays;
      row.cells[3].value =
          DateFormat('h:mm a MM dd, yyyy').format(item.createdAt);
    }

// Set grid format.
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document.
    final List<int> documentData = await document.save();
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(documentData)}")
      ..setAttribute("download", "output.pdf")
      ..click();

    document.dispose();
    snack(context, 'PDF Saved', info: true);
  } catch (e) {
    log(e.toString());
    snack(context, e.toString());
  }
}

class GetSFTableCard extends StatelessWidget {
  GetSFTableCard({Key? key, required this.data}) : super(key: key);
  final List<UserModel> data;

  final TextEditingController searchController = TextEditingController();

  String get title => "Users";

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final query = MediaQuery.of(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0) +
                const EdgeInsets.only(top: 8.0),
            child: Row(children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacer(
                flex: query.isTablet
                    ? 1
                    : query.isLaptop
                        ? 2
                        : 4,
              ),

              const SizedBox(width: 18),
              Row(
                //
                children: [
                  //contrasting from and to elevated buttons

                  ElevatedButton.icon(
                    onPressed: () {
                      _showDatePicked(context, true);
                    },
                    icon: Consumer<UserState>(
                      builder: (context, userState, child) {
                        return Text(
                            'To: ${DateFormat.yMMMd().format(userState.startDate)}');
                      },
                    ),
                    label: const Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showDatePicked(context, false);
                    },
                    icon: Consumer<UserState>(
                      builder: (context, userState, child) {
                        return Text(
                            'To: ${DateFormat.yMMMd().format(userState.endDate)}');
                      },
                    ),
                    label: const Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                flex: 4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(Icons.search),
                  ),
                  // controller: searchController,
                  onChanged: (query) => userState.setSearchQuery(query),
                ),
              ),

              const SizedBox(width: 18),

              //save pdf elevation icon button

              SizedBox(
                width: 140,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await buildPdf(context, data);
                  },
                  style: ElevatedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(
                    Icons.save_alt,
                    size: 20,
                  ),
                  label: Text('Save Pdf'),
                ),
              ),

              const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: Container(
              child: SfDataGrid(
                source: DataSource(context: context, data: data),
                columns: <GridColumn>[
                  getGridColumn(
                      name: '#', width: ColumnWidthMode.fitByCellValue),
                  ...getColumns(),
                  getGridColumn(name: 'Actions', align: Alignment.centerRight),
                ],
                loadMoreViewBuilder: loadMoreViewBuilderWidget,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showDatePicked(BuildContext context, bool start) {
    final UserState userState = Provider.of<UserState>(
      context,
      listen: false,
    );
    showDatePicker(
      context: context,
      initialDate: start ? userState.startDate : userState.endDate,
      firstDate: start ? DateTime(1950) : userState.startDate,
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        if (start) {
          userState.startDate = pickedDate;
        } else {
          userState.endDate = pickedDate;
        }
      }
    });
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
        getGridColumn(name: 'Create At'),
        getGridColumn(name: 'Name'),
        getGridColumn(name: 'Phone'),
        getGridColumn(name: 'Email'),
      ];
}
