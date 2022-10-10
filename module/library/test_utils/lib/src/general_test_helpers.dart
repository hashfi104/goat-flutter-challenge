// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTestGroup
void groupTest(Type toTestType, void Function() body, {dynamic skip}) {
  String description = toTestType.toString();
  for (int i = description.length - 1; i > 0; i--) {
    if (description[i] == description[i].toUpperCase()) {
      final before = description.substring(0, i);
      final after = description.substring(i, description.length);
      description = '$before ${after.toLowerCase()}';
    }
  }
  group(description, body, skip: skip);
}
