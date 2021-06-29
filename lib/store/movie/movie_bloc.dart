import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import 'package:lordoftherings_flutter/store/movie/movie_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc({required this.repository}) : super(const MovieState());

  @override
  Stream<Transition<MovieEvent, MovieState>> transformEvents(
    Stream<MovieEvent> events,
    TransitionFunction<MovieEvent, MovieState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieResetFetched) {
      yield await _mapResetFetchMoviesToState(state);
    }

    if (event is MovieFetched) {
      yield await _mapFetchMoviesToState(state);
    }
  }

  Future<MovieState> _mapFetchMoviesToState(MovieState state) async {
    if (state.page > state.pages) return state;

    try {
      if (state.status == ApiRequestStatus.initial) {
        final data = await this.repository.fetchMovies(page: 1);
        return state.copyWith(
          status: ApiRequestStatus.success,
          movies: data.docs,
          appendedMovies: data.docs,
          page: data.page,
          pages: data.pages,
        );
      }

      final data = await this.repository.fetchMovies(page: state.page + 1);

      return state.copyWith(
        status: ApiRequestStatus.success,
        movies: List.of(state.movies)..addAll(data.docs),
        appendedMovies: data.docs,
        page: data.page,
        pages: data.pages,
      );
    } on Exception {
      return state.copyWith(status: ApiRequestStatus.failure);
    }
  }

  Future<MovieState> _mapResetFetchMoviesToState(MovieState state) async {
    final newState = state.copyWith(
      status: ApiRequestStatus.success,
      movies: [],
      appendedMovies: [],
      page: 0,
      pages: 0,
    );

    return await _mapFetchMoviesToState(newState);
  }
}
