import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:onesignalnotify_app/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize('7220271f-3bd5-4a7a-9e98-b21808859a46');
    OneSignal.Notifications.requestPermission(true).then((value) {
      print('signal value: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // The property useMaterial3 has been removed in recent versions of Flutter.
        // useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
