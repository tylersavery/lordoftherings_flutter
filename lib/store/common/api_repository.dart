import 'package:dio/dio.dart';

const API_BASE_URL = "https://the-one-api.dev/v2";

enum ApiRequestStatus { initial, success, failure }

abstract class ApiRepository {
  final Dio client;

  const ApiRepository(this.client);

  String _paramsToQueryString(Map<String, dynamic> params) {
    Map<String, String> _params = {};

    params.entries.forEach((element) {
      _params = {
        ..._params,
        ...{element.key: "${element.value}"}
      };
    });

    return Uri(queryParameters: _params).query;
  }

  Options get _options {
    return Options(headers: {
      'Authorization': "Bearer B6L_9DnST66HKzlH07-8",
    });
  }

  Future<Map<String, dynamic>> get(
    String path, [
    Map<String, dynamic> params = const {},
  ]) async {
    final query = _paramsToQueryString(params);
    final url = "$API_BASE_URL$path/?$query";
    final response = await this.client.get(url, options: this._options);
    return response.data;
  }
}
