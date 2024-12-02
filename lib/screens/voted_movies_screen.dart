import 'package:flutter/material.dart';
import '../helpers/file_helper.dart';

class VotedMoviesScreen extends StatefulWidget {
  @override
  _VotedMoviesScreenState createState() => _VotedMoviesScreenState();
}

class _VotedMoviesScreenState extends State<VotedMoviesScreen> {
  List<dynamic> votedMovies = [];

  @override
  void initState() {
    super.initState();
    _loadVotedMovies();
  }

  Future<void> _loadVotedMovies() async {
    final movies = await FileHelper.getSavedMovies();
    setState(() {
      votedMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voted Movies')),
      body: votedMovies.isEmpty
          ? Center(
              child: Text(
              'No movies voted yet ;).',
              style: TextStyle(
                fontFamily: 'Exo_2',
              ),
            ))
          : ListView.builder(
              itemCount: votedMovies.length,
              itemBuilder: (context, index) {
                final movie = votedMovies[index];
                return ListTile(
                  leading: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/movie.jpg'),
                  title: Text(
                    movie['title'],
                    style: TextStyle(
                      fontFamily: 'Exo_2',
                    ),
                  ),
                  subtitle: Text(
                    'Release Date: ${movie['release_date']}',
                    style: TextStyle(
                      fontFamily: 'Exo_2',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
