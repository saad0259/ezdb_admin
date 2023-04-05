import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/admin_dashboard_model.dart';
import '../../model/chart_data_model.dart';
import '../../model/enum/dashboard_filter_enum.dart';
import '../../state/user_state.dart';
import '../../util/snippet.dart';
import '../../view/responsive/extended_media_query.dart';
import 'dashboard_chart_view.dart';
import 'filter_dropdown.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    if (userState.userList.isEmpty) {
      userState.isLoading = true;
      try {
        await userState.loadUserdata();
      } catch (e) {
        snack(context, e.toString());
      }
      userState.isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 16),
            Consumer<UserState>(
              builder: (context, userState, child) {
                return FilterDropdown(
                  filter: userState.currentFilter,
                  onChange: (f) {
                    userState.currentFilter = f;
                  },
                );
              },
            ),
          ],
        ),
        Consumer<UserState>(
          builder: (context, userState, child) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              crossFadeState: userState.isLoading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: shimmerDashboardEffect(),
              secondChild: Column(children: [
                getTopCards(context, userState.adminDashboardModel,
                    userState.currentFilter.getName()),
                const SizedBox(height: 16),
                getCharts(context, userState.adminDashboardModel),
              ]),
            );
          },
        ),
      ]),
    );
  }

  Widget getCharts(BuildContext context, AdminDashboardModel? model) {
    final media = MediaQuery.of(context);
    final UserState userState = Provider.of<UserState>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: getInRows(rows: media.isLargeLaptop ? 1 : 2, children: [
        getTransactionsChart(
          'Users Per Day',
          model?.usersPerDay ?? [],
          userState.currentFilter.getName(),
        ),
        getTransactionsChart(
          'Searches',
          model?.searchesPerDay ?? [],
          userState.currentFilter.getName(),
        ),
      ]),
    );
  }

  Widget getTransactionsChart(
          String status, List<ChartDataModel> data, String filterName) =>
      DashboardChartView(
        title: "$status ",
        subtitle: "$status based on $filterName",
        chartData: data,
      );

  Widget getTopCards(
      BuildContext context, AdminDashboardModel? model, String filterName) {
    final media = MediaQuery.of(context);
    return getInRows(
      rows: media.isLargeLaptop ? 1 : 2,
      children: [
        getStatCard(context,
            iconData: Icons.person,
            data: model?.totalUsers.toString(),
            title: 'Total Users',
            filter: filterName),
        getStatCard(context,
            iconData: Icons.search,
            data: model?.totalSearches.toString(),
            title: 'Total Searches',
            filter: filterName),
      ],
    );
  }

  Widget getStatCard(
    BuildContext context, {
    required IconData iconData,
    required String? data,
    required String title,
    required String filter,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(iconData,
                        size: 48, color: Theme.of(context).colorScheme.primary),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        data == null
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: getLoader(),
                              )
                            : Text(data,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(filter, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getInRows({required List<Widget> children, int rows = 1}) {
    children = children
        .map((e) => Expanded(
            child: Padding(padding: const EdgeInsets.all(8.0), child: e)))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: children.sublist(0, children.length ~/ rows),
        ),
        Row(
          children: children.sublist(children.length ~/ rows, children.length),
        ),
      ]),
    );
  }
}
