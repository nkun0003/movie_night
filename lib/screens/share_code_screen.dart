import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // importing http from http package
import 'dart:convert';
import '../helpers/file_helper.dart';
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
      final url = Uri.parse(
        '${dotenv.env['MOVIE_NIGHT_API_BASE_URL']}start-session?device_id=E5446E3E-8BB4-4DC8-A82F-7F540E449195',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          sessionCode = data['code'];
          sessionId = data['session_id'];
          isLoading = false;
        });

        // Save the session ID
        await FileHelper.saveSessionId(sessionId!);
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
