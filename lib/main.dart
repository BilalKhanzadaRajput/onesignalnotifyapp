import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OneSignalExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OneSignalExample extends StatefulWidget {
  const OneSignalExample({super.key});

  @override
  _OneSignalExampleState createState() => _OneSignalExampleState();
}

class _OneSignalExampleState extends State<OneSignalExample> {
  String _debugLabelString = "";
  late TextEditingController _playerIdController;
  String? _currentPlayerId;
  bool _privacyConsentGiven = false;

  @override
  void initState() {
    super.initState();
    _playerIdController = TextEditingController();
    initOneSignal();
  }

  @override
  void dispose() {
    _playerIdController.dispose();
    super.dispose();
  }

  void initOneSignal() async {
    // Set your OneSignal App ID
    await OneSignal.shared.setAppId("7220271f-3bd5-4a7a-9e98-b21808859a46");

    var deviceState = await OneSignal.shared.getDeviceState();
    _currentPlayerId = deviceState?.userId;

    // Print the player ID to the console
    if (kDebugMode) {
      print("Player ID: $_currentPlayerId");
    }

    // Check if privacy consent is given, and grant it if not already given
    if (!_privacyConsentGiven) {
      await OneSignal.shared.consentGranted(true);
      setState(() {
        _privacyConsentGiven = true;
      });
    }

    // Set notification opened and received handlers
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      setState(() {
        _debugLabelString = "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      setState(() {
        _debugLabelString = "Received notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
  }


  Future<void> sendNotification(String playerId) async {
    bool consent = await OneSignal.shared.userProvidedPrivacyConsent();

    if (consent) {
      // Create notification with recipient player ID
      var notification = OSCreateNotification(
        playerIds: [playerId],
        content: 'Your notification content here',
        heading: 'Notification Heading',
      );

      // Post the notification
      var response = await OneSignal.shared.postNotification(notification);

      if (response['success'] == true) {
        setState(() {
          _debugLabelString = 'Notification sent successfully to $playerId';
        });
      } else {
        setState(() {
          _debugLabelString = 'Failed to send notification to $playerId: ${response['errors']}';
        });
      }
    } else {
      setState(() {
        _debugLabelString = 'User has not provided privacy consent';
      });
    }
  }





  Future<void> generateNewPlayerId() async {
    var deviceState = await OneSignal.shared.getDeviceState();
    setState(() {
      _currentPlayerId = deviceState?.userId;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('OneSignal')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Player ID:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _currentPlayerId ?? 'Loading...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _playerIdController,
              decoration: const InputDecoration(
                hintText: 'Enter player ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String playerId = _playerIdController.text.trim();
                if (playerId.isNotEmpty) {
                  sendNotification(playerId);
                } else {
                  setState(() {
                    _debugLabelString = 'Player ID cannot be empty';
                  });
                }
              },
              child: const Text('Send Notification'),
            ),

            if (_debugLabelString.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                _debugLabelString,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
