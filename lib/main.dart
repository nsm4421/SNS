import 'package:flutter/material.dart';
import 'package:presentation/core/di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karma',
      theme: ThemeData.dark(useMaterial3: true),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(appBar: AppBar(title: Text("TEST"))),
      ),
    );
  }
}
