import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add a variable to hold the user ID
  String? currentUser; // Change the type according to your user ID data type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: TextButton(
                  onPressed: () {
                    if (currentUser != null) {
                      sendOneSignalNotification(currentUser!);
                    } else {
                      log('User ID is not available');
                    }
                  },
                  child: Text("Push Notification"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendOneSignalNotification(String userId) async {
    const String apiUrl = 'https://onesignal.com/api/v1/notifications';
    const String apiKey =
        'MzA1NWI3OWUtNDBlMi00MjAzLWE3NTgtZDRjNWIwNDVlZjBj';

    final Map<String, dynamic> requestBody = {
      "app_id": "7220271f-3bd5-4a7a-9e98-b21808859a46",
      "included_segments": ["Active Users"],
      "filters": [
        {"field": "tag", "key": "userId", "relation": "=", "value": userId}
      ],
      "headings": {"en": "You have a new message"},
      "contents": {"en": "Hey there!"},

    };

    final Map<String, String> headers = {
      'Authorization': 'Basic $apiKey',
      'Content-Type': 'application/json',
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully');
        log(response.body);
      } else {
        log('Failed to send notification. Status code: ${response.statusCode}');
        log(response.body);
      }
    } catch (error) {
      log('Error sending notification: $error');
    }
  }


  void setUser(String userId) {
    setState(() {
      currentUser = userId;
    });
  }


  void simulateLogin() {

    String userId = "user123";
    setUser(userId);
  }

  @override
  void initState() {
    super.initState();

    simulateLogin();
  }
}
