import 'package:flutter/material.dart';
import 'package:lordoftherings_flutter/screens/movie_detail_screen.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.name),
      leading: Icon(Icons.movie),
      trailing: Icon(Icons.chevron_right),
      subtitle: Text("${movie.rottenTomatoesScore.round()}"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => MovieDetailScreen(movie),
          ),
        );
      },
    );
  }
}
