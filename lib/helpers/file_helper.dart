import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/voted_movies.json');
  }

  static Future<void> saveMovie(Map<String, dynamic> movie) async {
    try {
      final file = await _getLocalFile();
      List<dynamic> movies = [];

      // check if the file already exists
      if (await file.exists()) {
        final content = await file.readAsString();
        movies = json.decode(content);
      }

      // avoid duplicates by checking for the movie ID
      if (!movies.any((m) => m['id'] == movie['id'])) {
        movies.add(movie); // here adding the new movie to the list
      }

      // write the updated list back to the file
      await file.writeAsString(json.encode(movies));
    } catch (e) {
      print('Error saving movie: $e');
    }
  }

  static Future<List<dynamic>> getSavedMovies() async {
    try {
      final file = await _getLocalFile();

      if (await file.exists()) {
        final content = await file.readAsString();
        return json.decode(content);
      }

      return [];
    } catch (e) {
      print('Error reading saved movies: $e');
      return [];
    }
  }
}
