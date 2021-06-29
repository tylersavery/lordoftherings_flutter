import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/components/movie_card.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/movie/movie_bloc.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import 'package:lordoftherings_flutter/store/movie/movie_repository.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieBloc>(
      create: (ctx) =>
          MovieBloc(repository: MovieRepository(Dio()))..add(MovieFetched()),
      child: MovieList(),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({
    Key? key,
  }) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final PagingController<int, MovieModel> _pagingController =
      PagingController(firstPageKey: 1);
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = context.read<MovieBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _movieBloc.add(MovieFetched());
    });
  }

  @override
  void didUpdateWidget(covariant MovieList oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
      listener: (context, state) {
        if (state.status == ApiRequestStatus.success) {
          if (state.page == state.pages) {
            _pagingController.appendLastPage(state.appendedMovies);
          } else {
            _pagingController.appendPage(state.appendedMovies, state.page + 1);
          }
        }
      },
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(child: Text("Error"));
            case ApiRequestStatus.success:
              return RefreshIndicator(
                onRefresh: () => Future.sync(
                  () {
                    _pagingController.refresh();
                    _movieBloc.add(MovieResetFetched());
                  },
                ),
                child: PagedListView<int, MovieModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<MovieModel>(
                    itemBuilder: (context, movie, index) {
                      return MovieCard(movie);
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
