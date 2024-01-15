import 'package:flutter/material.dart';
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
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
            backgroundColor: Colors.transparent,
            actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
            iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.black,
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              iconColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.black
          ),

      ),
        theme: ThemeData(  
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
            // actionsIconTheme:
            // IconThemeData(color: Theme.of(context).colorScheme.primary),
            // iconTheme:
            // IconThemeData(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        home: AppsPage(),
      ),
    );
  }
}
