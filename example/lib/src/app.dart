import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events/events.dart' as event;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.blueAccent),
    initialRoute: event.RouteNames.splash,
    getPages: event.RoutePages.pages,
    locale: const Locale('en','Us'),
    translationsKeys: event.LocalizationService.keys,
  );
}
