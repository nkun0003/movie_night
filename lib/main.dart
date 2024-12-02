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
          useMaterial3: true, // enabling Material 3 design
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors
                .teal, // defining primary color, i used seed instead of Swatch due to its dynamic nature of the color scheme
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontSize: 20, fontFamily: 'Exo_2', color: Colors.white),
          ),
          // make the appBar styling global
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            titleTextStyle: TextStyle(
              fontSize: 30,
              fontFamily: 'Exo_2',
              color: Colors.white,
            ),
          )),
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
