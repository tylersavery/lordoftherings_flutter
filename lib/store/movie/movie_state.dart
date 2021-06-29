part of 'movie_bloc.dart';

class MovieState extends Equatable {
  const MovieState({
    this.movies = const <MovieModel>[],
    this.appendedMovies = const <MovieModel>[],
    this.status = ApiRequestStatus.initial,
    this.page = 0,
    this.pages = 0,
  });

  final List<MovieModel> movies;
  final List<MovieModel> appendedMovies;
  final ApiRequestStatus status;
  final int page;
  final int pages;

  MovieState copyWith({
    ApiRequestStatus? status,
    List<MovieModel>? movies,
    List<MovieModel>? appendedMovies,
    int? page,
    int? pages,
  }) {
    return MovieState(
        status: status ?? this.status,
        movies: movies ?? this.movies,
        page: page ?? this.page,
        pages: pages ?? this.pages,
        appendedMovies: appendedMovies ?? []);
  }

  @override
  List<Object> get props => [status, movies, page, pages, appendedMovies];
}
