import 'package:flutter/material.dart';

import '../../model/admin_dashboard_model.dart';
import '../../model/chart_data_model.dart';
import '../../model/enum/dashboard_filter_enum.dart';
import '../../repo/dashboard_repo.dart';
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
  DashboardFilter filter = DashboardFilter.thisWeek;
  AdminDashboardModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadModel(DashboardFilter.thisWeek);
    });
  }

  void loadModel(DashboardFilter f) async {
    model = null;
    filter = f;
    if (mounted) {
      setState(() {});
    }
    model =
        await AdminDashboardRepo.instance.subscribeAdminDashboardData(filter);
    if (mounted) {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: 'Refresh',
              child: IconButton(
                onPressed: () => loadModel(filter),
                icon: const Icon(Icons.refresh),
              ),
            ),
            const SizedBox(width: 16),
            FilterDropdown(
              filter: filter,
              onChange: (f) => loadModel(f),
            ),
          ],
        ),
        Column(children: [
          getTopCards(context, model),
          const SizedBox(height: 16),
          getCharts(context, model),
        ]),
      ]),
    );
  }

  Widget getCharts(BuildContext context, AdminDashboardModel? model) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: getInRows(rows: media.isLargeLaptop ? 1 : 2, children: [
        getTransactionsChart('Users Per Day', model?.usersPerDay ?? []),
        getTransactionsChart('Searches', model?.searchesPerDay ?? []),
      ]),
    );
  }

  Widget getTransactionsChart(String status, List<ChartDataModel> data) =>
      DashboardChartView(
        title: "$status ",
        subtitle: "$status based on ${filter.getName()}",
        chartData: data,
      );

  Widget getTopCards(BuildContext context, AdminDashboardModel? model) {
    final media = MediaQuery.of(context);
    return getInRows(
      rows: media.isLargeLaptop ? 1 : 2,
      children: [
        getStatCard(context,
            iconData: Icons.person,
            data: model?.totalUsers.toString(),
            title: 'Total Users',
            filter: filter.getName()),
        getStatCard(context,
            iconData: Icons.search,
            data: model?.totalSearches.toString(),
            title: 'Total Searches',
            filter: filter.getName()),
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
