import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_keys.dart';
import '../helpers/file_helper.dart';

class MovieSelectionScreen extends StatefulWidget {
  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> movies = []; // holding the list of movies
  int currentIndex = 0; // tracks the currently displayed movie
  bool isLoading = false; // indicates if movies are being fetched
  int currentPage = 1; // tracks the current page for TMDB pagination

  @override
  void initState() {
    super.initState();
    _fetchMovies(); // fetch the first batch of movies when the screen loads
  }

  // fetch function that will call the movie
  Future<void> _fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          '${TMDB_BASE_URL}movie/popular?api_key=$TMDB_API_KEY&page=$currentPage');
      final response = await http.get(url);
      // if the response is successful display the movie as per below
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          movies.addAll(results.map((movie) => {
                'id': movie['id'],
                'title': movie['title'],
                'poster_path': movie['poster_path'],
                'release_date': movie['release_date'],
                'overview': movie['overview'],
              }));
          currentPage++; // increment page for the next fetch
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // fetch function for voting movies
  Future<void> _voteMovie(int movieId, bool vote) async {
    try {
      final sessionId = 'e15d1aaf-1dc5-464c-9168-86d153bbf3e1';
      final url = Uri.parse(
          '${MOVIE_NIGHT_API_BASE_URL}vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote');
      final response = await http.get(url);
      print('Vote API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        if (vote == true) {
          // saving the movie to a JSON file if voted "Yes"
          await FileHelper.saveMovie(movies[currentIndex]);
        }

        if (data['match'] == true) {
          // display a dialog when there’s a match
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'It’s a Match!',
                style: TextStyle(
                  fontFamily: 'Exo_2',
                ),
              ),
              content: Text(
                'You and your partner matched on ${data['movie_id']}!',
                style: TextStyle(fontFamily: 'Exo_2', fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close the dialog
                    Navigator.pop(context); // return to the Welcome Screen
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Error voting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Movie Choices')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // movie choices display
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Choices'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context,
                  '/voted_movies'); // here navigating to voted Movies Screen
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? Center(
              child: Text(
              'No movies available.',
              style: TextStyle(
                fontFamily: 'Exo_2',
              ),
            ))
          // making the image swiping
          : Dismissible(
              key: Key(movies[currentIndex]['id'].toString()),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                final movie = movies[currentIndex];
                final vote = direction == DismissDirection.endToStart
                    ? true
                    : false; // here where makes left for "No", right for "Yes"

                _voteMovie(movie['id'], vote);

                setState(() {
                  currentIndex++;
                  if (currentIndex >= movies.length) {
                    _fetchMovies(); // here telling the program to fetch more movies if at the end
                  }
                });
              },
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.thumb_up, color: Colors.white, size: 48),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Icon(Icons.thumb_down, color: Colors.white, size: 48),
              ),
              child: _buildMovieCard(movies[currentIndex]),
            ),
    );
  }

  // this build the movie card
  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          movie['poster_path'] != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  fit: BoxFit.cover,
                  height: 300,
                )
              : Image.asset(
                  'assets/images/movie.jpg',
                  height: 300,
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie['title'],
                    style: TextStyle(
                      fontSize: 24,
                    )),
                SizedBox(height: 8),
                Text(
                  'Release Date: ${movie['release_date']}',
                  style: TextStyle(
                    fontFamily: 'Exo_2',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  movie['overview'] ?? 'No description available.',
                  style: TextStyle(
                    fontFamily: 'Exo_2',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
