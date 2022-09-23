import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:router_book/router_book.dart';
import 'package:service_locator/service_locator.dart';
import 'package:ui_book/ui_book.dart';

final _localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  BookLocaleDelegate(),
];

class XYZBookApp extends StatelessWidget {
  final ServiceLocator locator;
  final Iterable<Locale> supportedLocales;

  const XYZBookApp({
    Key? key,
    required this.locator,
    required this.supportedLocales,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Put your entry in here
    List<RouteBase> entryRoutes = [];
    entryRoutes.addAll(
      BookEntry(locator: locator).routes,
    );
    final GoRouter router = GoRouter(routes: entryRoutes);

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      localizationsDelegates: _localizationsDelegates,
      title: 'XYZ Book App',
      debugShowCheckedModeBanner: false,
      supportedLocales: supportedLocales,
    );
  }
}
