import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // importing http from http package
import 'dart:convert';
// import 'package:platform_device_id/platform_device_id.dart'; // importing platform_device_id to handle the device ID

// import '../api_keys.dart'; // here importing the file containing my API configuration
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      // preparing the API URL with device_id as a query parameter
      final url = Uri.parse(
          '${dotenv.env['MOVIE_NIGHT_API_BASE_URL']}start-session?device_id=E5446E3E-8BB4-4DC8-A82F-7F540E449195');
      if (url == null) {
        print('MOVIE_NIGHT_API_BASE_URL is null!');
      }

      // makes the HTTP GET request
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          sessionCode = data['code']; // extract the session code
          sessionId = data['session_id']; // extract the session ID
          isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to start session. Please try again.';
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
                        style: TextStyle(fontSize: 24, fontFamily: 'Exo_2'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/movie_selection'),
                        child: Text(
                          'Start Matching',
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
