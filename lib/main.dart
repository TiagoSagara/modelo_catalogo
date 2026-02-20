import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/app_main.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(App());
}
