class AuthResponse {
  bool? status;
  Data? data;
  String? message;

  AuthResponse(
      {required this.status, required this.data, required this.message});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? Data.fromJson(json['data']) : null)!;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? jwtToken;
  User? user;

  Data({this.jwtToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    jwtToken = json['jwt_token'];
    user = (json['user'] != null ? User.fromJson(json['user']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jwt_token'] = jwtToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
  String? username;
  String? password;
  String? email;
  String? name;
  String? createdAt;

  User(
      {required this.sId,
      required this.username,
      required this.password,
      required this.email,
      required this.name,
      required this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['name'] = name;
    data['created_at'] = createdAt;
    return data;
  }
}
