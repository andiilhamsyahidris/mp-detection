import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:md_detection/src/presentation/states/detection_result_helper.dart';
import 'package:md_detection/src/presentation/states/mp_notifier.dart';
import 'package:provider/provider.dart';
import 'injection.dart' as di;

import 'src/presentation/features/initial/splash_page.dart';

class MdDetection extends StatelessWidget {
  const MdDetection({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MpNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<DetectionResultHelper>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MD Detection',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: const SplashPage(),
      ),
    );
  }
}
