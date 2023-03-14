import 'package:flutter/material.dart';

import '../../model/enum/dashboard_filter_enum.dart';

class FilterDropdown extends StatelessWidget {
  final DashboardFilter filter;
  final void Function(DashboardFilter filter) onChange;

  const FilterDropdown({
    Key? key,
    required this.filter,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<DashboardFilter>(
            items: DashboardFilter.values
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(e.getName()),
                    )))
                .toList(),
            onChanged: (value) => onChange(value ?? filter),
            value: filter,
          ),
        ),
      ),
    );
  }
}
