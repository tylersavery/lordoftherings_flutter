import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import 'package:lordoftherings_flutter/utils/formatting.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailScreen(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text(movie.name),
                pinned: true,
                forceElevated: innerBoxIsScrolled,
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
              color: Theme.of(context).primaryColorDark,
              child: Padding(
                padding: const EdgeInsets.all(8).copyWith(top: 110),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stat(
                          label: "Score",
                          value: movie.rottenTomatoesScore.round().toString(),
                        ),
                        Stat(
                          label: "Run Time",
                          value: formatMinutes(movie.runtimeInMinutes),
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stat(
                          label: "Nominations",
                          value: movie.academyAwardNominations.toString(),
                        ),
                        Stat(
                          label: "Wins",
                          value: movie.academyAwardWins.toString(),
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stat(
                          label: "Budget",
                          value: "${formatter.format(movie.budgetInMillions)}M",
                        ),
                        Stat(
                          label: "Revenue",
                          value:
                              "${formatter.format(movie.boxOfficeRevenueInMillions)}M",
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Text("Test1"),
            Text("Test2"),
          ],
        ),
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  const Stat({
    Key? key,
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: this.crossAxisAlignment,
      children: [
        Text(
          this.value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          this.label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
