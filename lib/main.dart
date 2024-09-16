import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/event_list_screen.dart';
import 'util/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panda Events',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventsListScreen(),
    );
  }
}
