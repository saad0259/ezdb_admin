import 'package:flutter/material.dart';
import 'package:mega_admin/app_theme.dart';

class ResponsiveHeightLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveHeightLayout({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appliedHeight = context.height > context.rMinHeight
        ? context.height
        : context.rMinHeight;
    final appliedWidth = context.width > context.rTabletWidth
        ? context.width
        : context.rTabletWidth;
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
