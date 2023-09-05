import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart';

import '../../model/admin_model.dart';
import '../../state/admin_state.dart';
import '../../util/sf_grid_helper.dart';
import '../../util/snippet.dart';

class AllAdminLogsScreen extends StatefulWidget {
  const AllAdminLogsScreen({Key? key}) : super(key: key);

  @override
  _AllAdminLogsScreenState createState() => _AllAdminLogsScreenState();
}

class _AllAdminLogsScreenState extends State<AllAdminLogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
    // loadData();
  }

  Future<void> loadData() async {
    final AdminState adminState =
        Provider.of<AdminState>(context, listen: false);
    if (adminState.admins.isEmpty) {
      // adminState.isLoading = true;
      await adminState.loadAllLogs();
      // adminState.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdminState adminState = Provider.of<AdminState>(context);
    return adminState.isLoading
        ? shimmerTableEffect()
        : Padding(
            padding: const EdgeInsets.all(32.0),
            child: GetSFTableCard(
              data: adminState.allLogs,
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
        // DataGridCell<String>(
        //     columnName: '',
        //     value:
        //         DateFormat('dd-MM-yyyy hh:mma').format(model.memberShipExpiry)),
        // DataGridCell<String>(columnName: '', value: model.name),
        DataGridCell<String>(columnName: '', value: model.email),
        DataGridCell<String>(
            columnName: '',
            value: DateFormat('dd-MM-yyyy hh:mma').format(model.createdAt)),
        DataGridCell<String>(
          columnName: '',
          value: model.contents,
        ),
      ];

  List<Widget> getActions(BuildContext context, AdminLogs model) => [];
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

Future<void> buildPdf(BuildContext context, List<AdminLogs> dataList) async {
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
    grid.columns.add(count: 2);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    // headerRow.cells[0].value = 'Name';
    headerRow.cells[0].value = 'Email';
    // headerRow.cells[2].value = 'Email';
    // headerRow.cells[3].value = 'Verified';
    // headerRow.cells[4].value = 'Days Left';
    headerRow.cells[1].value = 'Date';
// Set header font.
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid.

    for (AdminLogs item in dataList) {
      final PdfGridRow row = grid.rows.add();
      // row.cells[0].value = item.name;
      row.cells[0].value = item.email;
      // row.cells[2].value = item.email;
      // row.cells[3].value = item.isVerified ? 'Yes' : 'No';
      // row.cells[4].value = item.remainingDays;
      row.cells[1].value =
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
  final List<AdminLogs> data;

  final TextEditingController searchController = TextEditingController();

  String get title => "Admin Logs";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AdminState adminState =
        Provider.of<AdminState>(context, listen: false);
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
              // Spacer(
              //   flex: query.isTablet
              //       ? 1
              //       : query.isLaptop
              //           ? 2
              //           : 4,
              // ),

              const SizedBox(width: 18),
              // const SizedBox(width: 18),
              Expanded(
                flex: 4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(Icons.search),
                  ),
                  // controller: searchController,
                  onChanged: (query) => adminState.adminLogsSearchQuery = query,
                ),
              ),

              const SizedBox(width: 18),

              //save pdf elevation icon button
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
    final AdminState adminState = Provider.of<AdminState>(
      context,
      listen: false,
    );
    showDatePicker(
      context: context,
      initialDate: start ? adminState.startDate : adminState.endDate,
      firstDate: start ? DateTime(1950) : adminState.startDate,
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        if (start) {
          adminState.startDate = pickedDate;
        } else {
          adminState.endDate = pickedDate;
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
        // getGridColumn(name: 'Name'),
        getGridColumn(name: 'Email'),
        getGridColumn(name: 'Created On'),
        getGridColumn(name: 'Status'),
        // getGridColumn(name: 'Email'),
      ];
}
