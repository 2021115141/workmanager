import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/util/extension/dimens.dart';

import '/pages/welcome/welcome_page.dart';
import '/routing/app_routes.dart';
import '/routing/route_generator.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Work Manager',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      onGenerateRoute: RouteGenerator().onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'AvenirNextRoundedPro',
      ),
      home: const LinkApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LinkApp extends StatefulWidget {
  const LinkApp({Key? key}) : super(key: key);

  @override
  State<LinkApp> createState() => _LinkAppState();
}

class _LinkAppState extends State<LinkApp> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      String dynamicLinkString = dynamicLinkData.link.path;
      if (dynamicLinkString == AppRoutes.PATH_RESET_PASSWORD) {
        Get.toNamed(AppRoutes.RESET_PASSWORD,
            arguments: dynamicLinkData.link.queryParameters['oobCode']);
      }
    }).onError((error) {});
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: WelcomePage.instance(),
    );
  }
}
