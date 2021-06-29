import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import "package:rxdart/rxdart.dart";
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_repository.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository repository;

  QuoteBloc({required this.repository}) : super(const QuoteState());

  @override
  Stream<Transition<QuoteEvent, QuoteState>> transformEvents(
    Stream<QuoteEvent> events,
    TransitionFunction<QuoteEvent, QuoteState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<QuoteState> mapEventToState(QuoteEvent event) async* {
    print(event);
    if (event is QuoteFetched) {
      yield await _mapFetchQuotesToState(state);
    }

    if (event is QuoteResetFetched) {
      yield await _mapResetFetchQuotesToState(state);
    }
  }

  Future<QuoteState> _mapFetchQuotesToState(QuoteState state) async {
    if (state.page > state.pages) return state;

    try {
      if (state.status == ApiRequestStatus.initial) {
        final data = await this.repository.fetchQuotes(page: 1);

        return state.copyWith(
          status: ApiRequestStatus.success,
          quotes: data.docs,
          appendedQuotes: data.docs,
          page: data.page,
          pages: data.pages,
        );
      }

      final data = await this.repository.fetchQuotes(page: state.page + 1);
      return state.copyWith(
        status: ApiRequestStatus.success,
        quotes: List.of(state.quotes)..addAll(data.docs),
        appendedQuotes: data.docs,
        page: data.page,
        pages: data.pages,
      );
    } on Exception {
      return state.copyWith(status: ApiRequestStatus.failure);
    }
  }

  Future<QuoteState> _mapResetFetchQuotesToState(QuoteState state) async {
    final newState = state.copyWith(
      status: ApiRequestStatus.success,
      quotes: [],
      appendedQuotes: [],
      page: 0,
      pages: 0,
    );

    return await _mapFetchQuotesToState(newState);
  }
}

class MovieQuoteBloc extends Bloc<MovieQuoteEvent, QuoteState> {
  final QuoteRepository repository;
  final MovieModel movie;

  MovieQuoteBloc({required this.repository, required this.movie})
      : super(const QuoteState());

  @override
  Stream<Transition<MovieQuoteEvent, QuoteState>> transformEvents(
    Stream<MovieQuoteEvent> events,
    TransitionFunction<MovieQuoteEvent, QuoteState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<QuoteState> mapEventToState(MovieQuoteEvent event) async* {
    print(event);
    if (event is MovieQuoteFetched) {
      yield await _mapFetchQuotesToState(state);
    }

    if (event is MovieQuoteResetFetched) {
      yield await _mapResetFetchQuotesToState(state);
    }
  }

  Future<QuoteState> _mapFetchQuotesToState(QuoteState state) async {
    if (state.page > state.pages) return state;

    try {
      if (state.status == ApiRequestStatus.initial) {
        final data =
            await this.repository.fetchMovieQuotes(this.movie, page: 1);

        return state.copyWith(
          status: ApiRequestStatus.success,
          quotes: data.docs,
          appendedQuotes: data.docs,
          page: data.page,
          pages: data.pages,
        );
      }

      final data = await this
          .repository
          .fetchMovieQuotes(this.movie, page: state.page + 1);
      return state.copyWith(
        status: ApiRequestStatus.success,
        quotes: List.of(state.quotes)..addAll(data.docs),
        appendedQuotes: data.docs,
        page: data.page,
        pages: data.pages,
      );
    } on Exception {
      return state.copyWith(status: ApiRequestStatus.failure);
    }
  }

  Future<QuoteState> _mapResetFetchQuotesToState(QuoteState state) async {
    final newState = state.copyWith(
      status: ApiRequestStatus.success,
      quotes: [],
      appendedQuotes: [],
      page: 0,
      pages: 0,
    );

    return await _mapFetchQuotesToState(newState);
  }
}

class CharacterQuoteBloc extends Bloc<CharacterQuoteEvent, QuoteState> {
  final QuoteRepository repository;
  final CharacterModel character;

  CharacterQuoteBloc({required this.repository, required this.character})
      : super(const QuoteState());

  @override
  Stream<Transition<CharacterQuoteEvent, QuoteState>> transformEvents(
    Stream<CharacterQuoteEvent> events,
    TransitionFunction<CharacterQuoteEvent, QuoteState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<QuoteState> mapEventToState(CharacterQuoteEvent event) async* {
    if (event is CharacterQuoteFetched) {
      yield await _mapFetchQuotesToState(state);
    }
  }

  Future<QuoteState> _mapFetchQuotesToState(QuoteState state) async {
    if (state.page > state.pages) return state;
    try {
      if (state.status == ApiRequestStatus.initial) {
        final data =
            await this.repository.fetchCharacterQuotes(this.character, page: 1);
        return state.copyWith(
          status: ApiRequestStatus.success,
          quotes: data.docs,
          appendedQuotes: data.docs,
          page: data.page,
          pages: data.pages,
        );
      }

      final data = await this
          .repository
          .fetchCharacterQuotes(this.character, page: state.page + 1);

      return state.copyWith(
        status: ApiRequestStatus.success,
        quotes: List.of(state.quotes)..addAll(data.docs),
        appendedQuotes: data.docs,
        page: data.page,
        pages: data.pages,
      );
    } on Exception {
      return state.copyWith(status: ApiRequestStatus.failure);
    }
  }
}
