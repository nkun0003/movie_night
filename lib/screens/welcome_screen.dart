import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart'; // importing the package to get the device ID.

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() =>
      _WelcomeScreenState(); // creating a stateful widget for the dynamic content
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? deviceId; // here a variable to hold device ID.

  @override
  void initState() {
    super.initState();
    _getDeviceId(); // calling the function to fetch the device ID as soon as the screen loads
  }

  Future<void> _getDeviceId() async {
    deviceId = await PlatformDeviceId
        .getDeviceId; // fetching the device ID using the platform_device_id package.
    print(
        'Device ID: $deviceId'); // printing the device ID for debugging purposes.
  }

  @override
  Widget build(BuildContext context) {
    // here building the UI of the screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Night!'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/share_code'),
              child: Text(
                'Get a Code',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/enter_code'),
              child: Text(
                'Enter a Code',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
