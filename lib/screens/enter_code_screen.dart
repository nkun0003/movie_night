import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api_keys.dart'; // here importing the API configuration file

class EnterCodeScreen extends StatefulWidget {
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController =
      TextEditingController(); // this is a controller for the TextField
  bool isLoading = false; // to indicate loading state
  String? errorMessage; // to store any error messages

  // creating method to join the session
  Future<void> _joinSession(String code) async {
    setState(() {
      isLoading = true; // starting the loading spinner
      errorMessage = null; // clear any previous error message
    });

    try {
      // construct the URL with query parameters
      final url = Uri.parse(
        '${MOVIE_NIGHT_API_BASE_URL}join-session?device_id=E5446E3E-8BB4-4DC8-A82F-7F540E449195&code=$code',
      );

      // making the HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final sessionId = data['session_id']; // here extracting session_id

        // save session_id for future use (e.g., SharedPreferences, Provider, etc.)
        setState(() {
          isLoading = false; // stop the loading spinner
        });

        // navigate to the Movie Selection Screen
        Navigator.pushNamed(context, '/movie_selection');
      } else {
        // handling invalid code or other errors
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid code. Please try again!';
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
      appBar: AppBar(title: Text('Enter the Code')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // show a spinner during loading
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // textField to enter the code from your friend
                    TextField(
                      controller:
                          _codeController, // connect the TextField to the controller
                      keyboardType: TextInputType
                          .number, // this method only allow numeric input
                      maxLength: 4, // limiting input to 4 digits
                      decoration: InputDecoration(
                        labelText: 'Enter the Code from your friend',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final code = _codeController.text.trim();
                        if (code.length == 4) {
                          _joinSession(
                              code); // call the API if the code is valid
                        } else {
                          setState(() {
                            errorMessage = 'Please enter a 4-digit code.';
                          });
                        }
                      },
                      child: Text(
                        'Begin',
                        style: TextStyle(
                          fontFamily: 'Exo_2',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (errorMessage != null) // here display error messages
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
