import 'package:flutter/material.dart';

import 'extended_media_query.dart';

class ResponsiveHeightLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveHeightLayout({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    final height = query.size.height;
    final width = query.size.width;

    final appliedHeight = height > rMinHeight ? height : rMinHeight;
    final appliedWidth = width > rTabletWidth ? width : rTabletWidth;
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: appliedHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: appliedWidth,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
