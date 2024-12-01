import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // importing http from http package
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart'; // importing platform_device_id the handle the device ID

import '../api_keys.dart'; // here importing the file containing my API configuration

class ShareCodeScreen extends StatefulWidget {
  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

//this is the state class
class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? sessionCode; // here holding the generated session code
  String? sessionId; // here holding the session ID for later use
  bool isLoading = true; // and indicating whether the screen is loading
  String? errorMessage; // here holding any error messages from the API

  @override
  void initState() {
    super.initState();
    _startSession(); // trigger the API call when the screen is loaded
  }

  // this function triggers the API call to start a new session
  Future<void> _startSession() async {
    try {
      // fetching the device ID dynamically
      final deviceId = await PlatformDeviceId.getDeviceId;

      // preparing the API URL
      final url = Uri.parse('${MOVIE_NIGHT_API_BASE_URL}start-session');

      // making the HTTP GET request with the dynamic device ID
      final response = await http.get(url, headers: {'device_id': deviceId!});

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          sessionCode = data['code'];
          sessionId = data['session_id'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to start session. Please try again!';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share Code')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Text(errorMessage!,
                    style: TextStyle(
                        color: Colors.red)) // displaying the error message
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Code: $sessionCode', // displaying the session code
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/movie_selection'),
                        child: Text('Start Matching'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
