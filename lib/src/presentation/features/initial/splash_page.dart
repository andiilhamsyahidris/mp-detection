import 'dart:async';

import 'package:flutter/material.dart';
import 'package:md_detection/core/constant/asset_path.dart';
import 'package:md_detection/core/constant/color_const.dart';
import 'package:md_detection/src/presentation/features/home/homepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    // Will change page after two second
    super.didChangeDependencies();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        showHomePage(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Palette.purple),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Image.asset(
                AssetPath.getImages('logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
