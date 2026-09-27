import 'package:flutter/material.dart';
import 'package:yalla_5roga/app.dart';
import 'package:yalla_5roga/core/di/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deps = await AppDependencies.create();
  runApp(App(deps: deps));
}
