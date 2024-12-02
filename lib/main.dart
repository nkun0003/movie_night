import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/share_code_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/movie_selection_screen.dart';
import 'screens/voted_movies_screen.dart';

void main() => runApp(MovieNight());

class MovieNight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/', // WelcomeScreen is the starting screen
      routes: {
        '/': (context) => WelcomeScreen(),
        '/share_code': (context) => ShareCodeScreen(),
        '/enter_code': (context) => EnterCodeScreen(),
        '/movie_selection': (context) => MovieSelectionScreen(),
        '/voted_movies': (context) => VotedMoviesScreen(),
      },
    );
  }
}
