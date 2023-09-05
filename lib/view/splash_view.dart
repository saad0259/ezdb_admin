import '../contants/app_images.dart';
import '../util/snippet.dart';
import '../view/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeightLayout(
        child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImages.logo,
            fit: BoxFit.contain,
          ),
        ),
        Container(color: Colors.black.withOpacity(0.7)),
        Center(child: getLoader())
      ],
    ));
  }
}
