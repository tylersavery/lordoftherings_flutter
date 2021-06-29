import 'dart:async';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/character/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc({required this.repository}) : super(const CharacterState());

  @override
  Stream<Transition<CharacterEvent, CharacterState>> transformEvents(
    Stream<CharacterEvent> events,
    TransitionFunction<CharacterEvent, CharacterState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CharacterState> mapEventToState(CharacterEvent event) async* {
    if (event is CharacterResetFetched) {
      yield await _mapResetFetchCharactersToState(state);
    }

    if (event is CharacterFetched) {
      yield await _mapFetchCharactersToState(state);
    }
  }

  Future<CharacterState> _mapFetchCharactersToState(
      CharacterState state) async {
    if (state.page > state.pages) return state;

    try {
      if (state.status == ApiRequestStatus.initial) {
        final data = await this.repository.fetchCharacters(page: 1);
        return state.copyWith(
          status: ApiRequestStatus.success,
          characters: data.docs,
          appendedCharacters: data.docs,
          page: data.page,
          pages: data.pages,
        );
      }

      final data = await this.repository.fetchCharacters(page: state.page + 1);

      return state.copyWith(
        status: ApiRequestStatus.success,
        characters: List.of(state.characters)..addAll(data.docs),
        appendedCharacters: data.docs,
        page: data.page,
        pages: data.pages,
      );
    } on Exception {
      return state.copyWith(status: ApiRequestStatus.failure);
    }
  }

  Future<CharacterState> _mapResetFetchCharactersToState(
      CharacterState state) async {
    final newState = state.copyWith(
      status: ApiRequestStatus.success,
      characters: [],
      appendedCharacters: [],
      page: 0,
      pages: 0,
    );

    return await _mapFetchCharactersToState(newState);
  }
}
