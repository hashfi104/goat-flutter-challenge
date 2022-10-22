# Goat Flutter Challenge

XYZ Goat Flutter Challenge

Implement with `clean architecture` with multiple repo

## Demo

https://drive.google.com/file/d/17w_wrSPA-re610Qv2D6kWzRSsFFhVp-T/view?usp=sharing

## Prequisite

- Flutter SDK : v3.3.3
- Dart SDK: v2.18.0

## How to Build

### 1. Activate melos.
open your terminal and run this command:

````shell
dart pub global activate melos
````
melos is a tools to support multiple package flutter app, so we don't create a monolythic app.

reference : https://medium.com/flutter-community/managing-multi-package-flutter-projects-with-melos-c8ce96fa7c82

### 2. Dowload all dependency library using - melos bs
to download all the dependency you need to run the following commands, 
this command will run `flutter pub get` for all modules. 
Doing that will be problematic because this project is contains multiple modules.

So, melos will make it easier to do that.

open terminal and run this command:

````shell
melos bs
````

## List Of Modules

1. Library
   1. `assets` - contain all the asset for all the icon
   2. `components` - contain all the basic components for basic ui
   3. `cubit_utils` - contain util that can be used for create cubit and cubit state
   4. `localization` - library for generate localization automatically for every ui module
   5. `networking` - for calling API using library called `dio`
   6. `result_util` - containing helper for wraping api Result
   7. `service_locator` - for dependency injection using `GetIt`
   8. `test_utils` - containing util related testing, also containing script to generate `coverage_test` file.

2. Entity 
   1. `entity_book` - contain models related api and also `interface` for Domain and Data Layer


3. Domain
   1. `domain_book` - contain useCase in domain layer


4. Data 
   1. `data_book` - contain implementation of `entity_book` interface using `networking`


5. UI (unit test partly written for pages)
   1. `ui_book` - contain code for all the screens

6. Router
   1. `router_book` - contain code for navigation between screen