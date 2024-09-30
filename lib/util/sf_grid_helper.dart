import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

Widget loadMoreViewBuilderWidget(
    BuildContext context, LoadMoreRows loadMoreRows) {
  bool showIndicator = false;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    if (showIndicator) {
      return Card(
        elevation: 0,
        child: Container(
            height: 50.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(
                        width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
            child: const CircularProgressIndicator()),
      );
    } else {
      return Card(
        elevation: 0,
        child: Container(
            height: 50.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(
                        width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
            child: SizedBox(
                height: 36.0,
                width: 142.0,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor)),
                    child: const Text('LOAD MORE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (context is StatefulElement && context.state.mounted) {
                        setState(() {
                          showIndicator = true;
                        });
                      }
                      await loadMoreRows();
                      if (context is StatefulElement && context.state.mounted) {
                        setState(() {
                          showIndicator = false;
                        });
                      }
                    }))),
      );
    }
  });
}
