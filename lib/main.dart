import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'apps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Launcher',
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
            iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
          ),
      ),
        theme: ThemeData(  
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
            iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
          )
        ),
        home: AppsPage(),
      ),
    );
  }
}
