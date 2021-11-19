import 'package:dio/dio.dart';
import 'package:nirikshan_recon/models/auth_response.dart';
import 'package:nirikshan_recon/models/dump_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<AuthResponse> login(String username, String password) async {
    try {
      var response = await dio.post("$baseUrl/login",
          data: {"username": username, "password": password});
      if (response.statusCode == 200) {
        var resp = AuthResponse.fromJson(response.data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', resp.data!.jwtToken!);
        await prefs.setString('name', resp.data!.user!.name!);
        await prefs.setBool('loggedIn', true);
        return resp;
      } else {
        throw Future.error('Failed to login');
      }
    } catch (e) {
      throw Future.error('Failed to login');
    }
  }

  Future<bool> signup(
      String username, String password, String name, String email) async {
    try {
      var response = await dio.post("$baseUrl/signup", data: {
        "username": username,
        "password": password,
        "name": name,
        "email": email,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Future.error('Failed to login');
      }
    } catch (e) {
      throw Future.error('Failed to login');
    }
  }
}
