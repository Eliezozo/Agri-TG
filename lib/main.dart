import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Hive et ouverture des boîtes de cache
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox('auth_cache'),
    Hive.openBox('transactions_cache'),
    Hive.openBox('votes_cache'),
    Hive.openBox('reports_cache'),
  ]);

  runApp(
    const ProviderScope(
      child: AgriTGApp(),
    ),
  );
}
