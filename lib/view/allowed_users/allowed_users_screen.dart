import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezdb_admin/app_theme.dart';
import 'package:ezdb_admin/state/allowed_users_state.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../flutter-utils/snippets/dialogs.dart';
import '../../flutter-utils/snippets/reusable_widgets.dart';
import '../../flutter-utils/snippets/routing_helpers.dart';
import '../../flutter-utils/snippets/shimmers_effects.dart';
import '../../repo/admins_repo.dart';
import '../../state/auth_state.dart';
import '../../util/sf_grid_helper.dart';

class AllowedUsersScreen extends StatefulWidget {
  const AllowedUsersScreen({super.key});

  @override
  State<AllowedUsersScreen> createState() => _AllowedUsersScreenState();
}

class _AllowedUsersScreenState extends State<AllowedUsersScreen> {
  Future<void> loadData() async {
    final AllowedUsersState state =
        Provider.of<AllowedUsersState>(context, listen: false);
    await state.loadData();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AllowedUsersState state = Provider.of<AllowedUsersState>(context);
    return state.isLoading
        ? shimmerTableEffect()
        : Padding(
            padding: const EdgeInsets.all(32.0),
            child: GetSFTableCard(
              data: state.allowedUsers,
            ),
          );
  }
}

class GetSFTableCard extends StatelessWidget {
  GetSFTableCard({Key? key, required this.data}) : super(key: key);
  final List<String> data;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AllowedUsersState state =
        Provider.of<AllowedUsersState>(context, listen: false);
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
              Spacer(
                flex: context.isTablet
                    ? 1
                    : context.isLaptop
                        ? 2
                        : 4,
              ),

              const SizedBox(width: 18),
              // Row(
              //   //
              //   children: [
              //     //contrasting from and to elevated buttons

              //     ElevatedButton.icon(
              //       onPressed: () {
              //         _showDatePicked(context, true);
              //       },
              //       icon: Consumer<AllowedUsersState>(
              //         builder: (context, userState, child) {
              //           return Text(
              //               'To: ${DateFormat.yMMMd().format(userState.startDate)}');
              //         },
              //       ),
              //       label: const Icon(
              //         Icons.arrow_drop_down,
              //         size: 20,
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         foregroundColor: Colors.black,
              //         backgroundColor: Colors.white,
              //       ),
              //     ),
              //     const SizedBox(width: 18),
              //     ElevatedButton.icon(
              //       onPressed: () {
              //         _showDatePicked(context, false);
              //       },
              //       icon: Consumer<UserState>(
              //         builder: (context, userState, child) {
              //           return Text(
              //               'To: ${DateFormat.yMMMd().format(userState.endDate)}');
              //         },
              //       ),
              //       label: const Icon(
              //         Icons.arrow_drop_down,
              //         size: 20,
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         foregroundColor: Colors.black,
              //         backgroundColor: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(width: 18),
              Expanded(
                flex: 4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(Icons.search),
                  ),
                  // controller: searchController,
                  onChanged: (query) => state.searchQuery = query,
                ),
              ),

              const SizedBox(width: 18),

              //save pdf elevation icon button

              SizedBox(
                width: 140,
                child: ElevatedButton.icon(
                  onPressed: () => addUserMethod(context, state),
                  style: ElevatedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                  ),
                  label: Text('Add'),
                ),
              ),
              // const SizedBox(width: 18),

              // //save pdf elevation icon button

              // SizedBox(
              //   width: 140,
              //   child: ElevatedButton.icon(
              //     onPressed: () async {
              //       // await buildPdf(context, data);
              //     },
              //     style: ElevatedButton.styleFrom(
              //       visualDensity: VisualDensity.compact,
              //     ),
              //     icon: const Icon(
              //       Icons.save_alt,
              //       size: 20,
              //     ),
              //     label: Text('Save Pdf'),
              //   ),
              // ),

              // const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No Data Found',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                : Container(
                    child: SfDataGrid(
                      source: DataSource(context: context, data: data),
                      columns: <GridColumn>[
                        getGridColumn(name: '#', width: ColumnWidthMode.none),
                        ...getColumns(),
                        // getGridColumn(name: 'Actions', align: Alignment.centerRight),
                      ],
                      loadMoreViewBuilder: loadMoreViewBuilderWidget,
                    ),
                  ),
          ),
        ]),
      ),
    );
  }

  void addUserMethod(BuildContext context, AllowedUsersState state) {
    {
      final formKey = GlobalKey<FormState>();
      String phone = '';

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text('Add User to Allowed List'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => phone = value,
                      onSaved: (newValue) => phone = newValue.toString(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final AuthState authState =
                                Provider.of<AuthState>(context, listen: false);
                            getStickyLoader(context);
                            await state.addAllowedUser(phone);
                            AdminRepo.instance.addAdminLogs(
                                authState.admin!.email,
                                'Added ${phone} to allowed list');
                            snack(context, 'User added successfully',
                                info: true);
                          } catch (e) {
                            snack(context, e.toString());
                          } finally {
                            pop(context);
                            pop(context);
                            await state.loadData();
                          }
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              )));
    }
  }

  // void _showDatePicked(BuildContext context, bool start) {
  //   final AllowedUsersState state = Provider.of<AllowedUsersState>(
  //     context,
  //     listen: false,
  //   );
  //   showDatePicker(
  //     context: context,
  //     initialDate: start ? state.startDate : state.endDate,
  //     firstDate: start ? DateTime(1950) : state.startDate,
  //     lastDate: DateTime.now(),
  //   ).then((pickedDate) {
  //     if (pickedDate != null) {
  //       if (start) {
  //         state.startDate = pickedDate;
  //       } else {
  //         state.endDate = pickedDate;
  //       }
  //     }
  //   });
  // }

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
        getGridColumn(name: 'Phone', width: ColumnWidthMode.fill),
        getGridColumn(name: 'Actions'),
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
  final List<String> data;
  List<String> availableData = [];

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

  List<DataGridCell> getCells(String model) => [
        DataGridCell<String>(columnName: '', value: model),
        // DataGridCell<String>(
        //     columnName: '',
        //     value: DateFormat('dd-MM-yyyy hh:mma').format(model.createdAt)),
        // DataGridCell<String>(columnName: '', value: model.name),
        // DataGridCell<String>(
        //     columnName: '',
        //     value:
        //         DateFormat('dd-MM-yyyy hh:mma').format(model.memberShipExpiry)),
        // DataGridCell<String>(columnName: '', value: model.email),
      ];

  List<Widget> getActions(BuildContext context, String model) => [
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
            tooltip: 'Remove User',
            onPressed: () async {
              final AllowedUsersState state = Provider.of<AllowedUsersState>(
                context,
                listen: false,
              );
              try {
                getStickyLoader(context);
                final AuthState authState =
                    Provider.of<AuthState>(context, listen: false);

                await state.deleteAllowedUser(model);
                AdminRepo.instance.addAdminLogs(authState.admin!.email,
                    'Removed ${model} from allowed list');
                snack(context, 'User Removed', info: true);
              } catch (e) {
                snack(context, 'Something went wrong');
              } finally {
                pop(context);
                await state.loadData();
              }
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
    for (String model in availableData) {
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

  void _addMoreRows(List<String> newData, int count) {
    final startIndex = newData.isNotEmpty ? newData.length : 0,
        endIndex = (startIndex + count) >= data.length
            ? data.length
            : startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
      newData.add(data[i]);
    }
  }
}
