import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/hibe_date_store.dart';
import 'package:todo_app/models/task.dart';

import 'package:todo_app/views/home/home.dart';

late Box box;
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  Box box = await Hive.openBox<Task>(HiveDateStore.boxName);

  for (var task in box.values) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    }
  }
  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);
  final HiveDateStore dataStore = HiveDateStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget fom tyep BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            displayMedium: TextStyle(
              color: Colors.white,
              fontSize: 21,
            ),
            displaySmall: TextStyle(
                color: Color.fromARGB(255, 234, 234, 234),
                fontSize: 14,
                fontWeight: FontWeight.w400),
            headlineMedium: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            headlineSmall: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            titleSmall:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            titleLarge: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w300)),
      ),
      // home: const TaskView(),
      home: const Home(),
    );
  }
}
