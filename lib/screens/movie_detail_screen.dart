import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lordoftherings_flutter/components/quote_card.dart';
import 'package:lordoftherings_flutter/components/stat.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_bloc.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_repository.dart';
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
        body: BlocProvider<MovieQuoteBloc>(
          create: (ctx) => MovieQuoteBloc(
            movie: this.movie,
            repository: QuoteRepository(
              Dio(),
            ),
          )..add(
              MovieQuoteFetched(),
            ),
          child: MovieQuoteList(),
        ),
      ),
    );
  }
}

class MovieQuoteList extends StatefulWidget {
  const MovieQuoteList({Key? key}) : super(key: key);

  @override
  _MovieQuoteListState createState() => _MovieQuoteListState();
}

class _MovieQuoteListState extends State<MovieQuoteList> {
  final PagingController<int, QuoteModel> _pagingController =
      PagingController(firstPageKey: 1);

  late MovieQuoteBloc _movieQuoteBloc;

  @override
  void initState() {
    _movieQuoteBloc = context.read<MovieQuoteBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _movieQuoteBloc.add(MovieQuoteFetched());
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieQuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state.status == ApiRequestStatus.success) {
          if (state.page == state.pages) {
            _pagingController.appendLastPage(state.appendedQuotes);
          } else {
            _pagingController.appendPage(state.appendedQuotes, state.page + 1);
          }
        }
      },
      child: BlocBuilder<MovieQuoteBloc, QuoteState>(
        builder: (context, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(child: Text("Error"));
            case ApiRequestStatus.success:
              return RefreshIndicator(
                onRefresh: () => Future.sync(
                  () {
                    _pagingController.refresh();
                    _movieQuoteBloc.add(MovieQuoteResetFetched());
                  },
                ),
                child: PagedListView<int, QuoteModel>(
                  padding: EdgeInsets.zero,
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<QuoteModel>(
                    itemBuilder: (context, quote, index) {
                      return QuoteCard(quote);
                    },
                  ),
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
