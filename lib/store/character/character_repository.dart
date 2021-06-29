import 'package:dio/dio.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/common/response_model.dart';

class CharacterRepository extends ApiRepository {
  final Dio client;

  const CharacterRepository(this.client) : super(client);

  Future<ResponseListModel<CharacterModel>> fetchCharacters({
    int page = 1,
    int limit = 30,
  }) async {
    final params = {
      ...this.page(page),
      ...this.limit(limit),
    };

    final data = await this.get('/character', params);
    final List<CharacterModel> docs = data['docs']
        .map<CharacterModel>((doc) => new CharacterModel.fromJson(doc))
        .toList();

    return ResponseListModel(
      page: data['page'],
      pages: data['pages'],
      docs: docs,
    );
  }
}
