import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/health_repository.dart';

void main() {
  runApp(HealthApp(repository: AssetHealthRepository()));
}
