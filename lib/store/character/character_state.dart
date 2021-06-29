part of 'character_bloc.dart';

class CharacterState extends Equatable {
  const CharacterState({
    this.characters = const <CharacterModel>[],
    this.appendedCharacters = const <CharacterModel>[],
    this.status = ApiRequestStatus.initial,
    this.page = 0,
    this.pages = 0,
  });

  final List<CharacterModel> characters;
  final List<CharacterModel> appendedCharacters;
  final ApiRequestStatus status;
  final int page;
  final int pages;

  CharacterState copyWith({
    ApiRequestStatus? status,
    List<CharacterModel>? characters,
    List<CharacterModel>? appendedCharacters,
    int? page,
    int? pages,
  }) {
    return CharacterState(
        status: status ?? this.status,
        characters: characters ?? this.characters,
        page: page ?? this.page,
        pages: pages ?? this.pages,
        appendedCharacters: appendedCharacters ?? []);
  }

  @override
  List<Object> get props =>
      [status, characters, page, pages, appendedCharacters];
}
