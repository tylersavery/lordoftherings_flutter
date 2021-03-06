import 'package:dio/dio.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/common/response_model.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';

class QuoteRepository extends ApiRepository {
  final Dio client;

  const QuoteRepository(this.client) : super(client);

  Future<ResponseListModel<QuoteModel>> fetchQuotes({
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      ...this.page(page),
      ...this.limit(limit),
    };

    final data = await this.get('/quote', params);
    final List<QuoteModel> docs = data['docs']
        .map<QuoteModel>((doc) => new QuoteModel.fromJson(doc))
        .toList();

    return ResponseListModel(
      page: data['page'],
      pages: data['pages'],
      docs: docs,
    );
  }

  Future<ResponseListModel<QuoteModel>> fetchMovieQuotes(
    MovieModel movie, {
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      ...this.page(page),
      ...this.limit(limit),
    };

    final data = await this.get('/movie/${movie.id}/quote', params);
    final List<QuoteModel> docs = data['docs']
        .map<QuoteModel>((doc) => new QuoteModel.fromJson(doc))
        .toList();

    return ResponseListModel(
      page: data['page'],
      pages: data['pages'],
      docs: docs,
    );
  }

  Future<ResponseListModel<QuoteModel>> fetchCharacterQuotes(
    CharacterModel character, {
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      ...this.page(page),
      ...this.limit(limit),
    };

    final data = await this.get('/character/${character.id}/quote', params);
    final List<QuoteModel> docs = data['docs']
        .map<QuoteModel>((doc) => new QuoteModel.fromJson(doc))
        .toList();

    return ResponseListModel(
      page: data['page'],
      pages: data['pages'],
      docs: docs,
    );
  }
}
