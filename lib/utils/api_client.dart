import 'package:dio/dio.dart';
import 'package:nirikshan_recon/models/dump_response.dart';

class ApiClient {
  late Dio dio;
  late String baseUrl;
  ApiClient(token, this.baseUrl) {
    dio = Dio();
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = baseUrl;
  }

  Future<DumpResponse> getDumpData(String site) async {
    var response =
        await dio.get("$baseUrl/dump", queryParameters: {"site": site});
    if (response.statusCode == 200) {
      return DumpResponse.fromJson(response.data);
    } else {
      throw Future.error('Failed to load dump data');
    }
  }
}
