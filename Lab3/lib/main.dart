import 'package:flutter/material.dart';

import 'app.dart';
import 'injection.dart';

void main() {
  runApp(HealthApp(dependencies: AppDependencies.live()));
}
