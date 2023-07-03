import 'package:flutter/material.dart';
import 'package:md_detection/core/constant/app_route.dart';
import 'package:md_detection/core/constant/asset_path.dart';
import 'package:md_detection/core/constant/color_const.dart';
import 'package:md_detection/core/constant/text_const.dart';
import 'package:md_detection/src/presentation/features/detail/detail_page.dart';

void showHomePage({required BuildContext context}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Homepage(),
        settings: const RouteSettings(
          name: AppRoute.homePage,
        ),
      ),
      (route) => false);
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              AssetPath.getImages('bg.png'),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 720,
            left: MediaQuery.of(context).size.width / 6,
            child: Image.asset(
              AssetPath.getImages('logo.png'),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 460,
            left: MediaQuery.of(context).size.width / 4 - 35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'MP\nDETECTION',
                    textAlign: TextAlign.center,
                    style: kTextTheme.headlineMedium?.copyWith(
                      color: Palette.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    'Deteksi Penyakit Cacar Monyet\n(Monkeypox)',
                    textAlign: TextAlign.center,
                    style: kTextTheme.bodyMedium?.copyWith(
                      color: Palette.purpleLight,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Flexible(
                  child: InkWell(
                    onTap: () => showCamera(context: context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 60,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'DETEKSI',
                        style: kTextTheme.bodyLarge?.copyWith(
                          color: Palette.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Text(
                    'MP Detection merupakan aplikasi pendeteksi\ncacar monyet (Monkeypox)',
                    textAlign: TextAlign.center,
                    style: kTextTheme.bodySmall?.copyWith(
                      color: Palette.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
