import 'package:dio/dio.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/common/response_model.dart';
import 'package:lordoftherings_flutter/store/movie/movie_model.dart';

class MovieRepository extends ApiRepository {
  final Dio client;

  const MovieRepository(this.client) : super(client);

  Future<ResponseListModel<MovieModel>> fetchMovies({
    int page = 1,
    int limit = 10,
  }) async {
    final params = {
      ...this.page(page),
      ...this.limit(limit),
    };

    final data = await this.get('/movie', params);

    final List<MovieModel> docs = data['docs']
        .map<MovieModel>((doc) => new MovieModel.fromJson(doc))
        .toList();

    return ResponseListModel(
      page: data['page'],
      pages: data['pages'],
      docs: docs,
    );
  }
}
