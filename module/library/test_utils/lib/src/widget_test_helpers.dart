// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:test_utils/src/fakeclient/fake_http_overrides.dart';

import 'report_utils.dart';

@isTest
void testPage(
  String description, {
  required Widget Function() pageBuilder,
  required LocalizationsDelegate localizationsDelegate,
  required Future<void> Function(WidgetTester) then,
  bool? skip,
  Iterable<String>? tags,
}) {
  final formattedDescription = formatDescription(description, tags);
  testWidgets(formattedDescription, (tester) async {
    HttpOverrides.global = FakeHttpOverrides();
    await tester.pumpWidget(MaterialApp(
      home: pageBuilder.call(),
      localizationsDelegates: [localizationsDelegate],
    ));

    // additional pump for view initialization
    await tester.pump();
    await then(tester);
  }, skip: skip, tags: tags);
}
