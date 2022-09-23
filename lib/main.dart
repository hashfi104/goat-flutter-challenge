import 'dart:async';

import 'package:data_book/data_book.dart';
import 'package:domain_book/domain_book.dart';
import 'package:flutter/material.dart';
import 'package:goat_flutter_challenge/xyz_book_app.dart';
import 'package:networking/networking.dart';
import 'package:service_locator/service_locator.dart';

void main() {
  runZonedGuarded(() async {
    // setup service locator
    ServiceLocatorInitiator.setServiceLocatorFactory(
      () => GetItServiceLocator(),
    );
    final locator = ServiceLocator.asNewInstance();

    // inject all dependency with registering all the registrar
    await Future.wait([
      locator.registerRegistrar(NetworkRequestRegistrar(
        baseURL: 'https://gutendex.com',
      )),
      locator.registerRegistrar(DomainBookRegistrar()),
      locator.registerRegistrar(DataBookRegistrar()),
    ]);

    runApp(
      XYZBookApp(
        locator: locator,
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('id', 'ID'), // for indonesia
        ],
      ),
    );
  }, (error, stackTrace) {
    // todo: uncomment this when connect to firebase crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
