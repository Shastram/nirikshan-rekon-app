class DumpResponse {
  late bool status;
  late Data data;
  late String message;

  DumpResponse(
      {required this.status, required this.data, required this.message});

  DumpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? Data.fromJson(json['data']) : null)!;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data.toJson();
    data['message'] = message;
    return data;
  }
}

class Data {
  late List<Logs> logs;
  late int totalLength;
  late int blacklistLength;

  Data(
      {required this.logs,
      required this.totalLength,
      required this.blacklistLength});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs.add(Logs.fromJson(v));
      });
    }
    totalLength = json['total_length'];
    blacklistLength = json['blacklist_length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logs'] = logs.map((v) => v.toJson()).toList();
    data['total_length'] = totalLength;
    data['blacklist_length'] = blacklistLength;
    return data;
  }
}

class Logs {
  late String siteId;
  late String siteName;
  late String os;
  late String browser;
  late String ip;
  late String time;
  late bool isBlackListed;

  Logs(
      {required this.siteId,
      required this.siteName,
      required this.os,
      required this.browser,
      required this.ip,
      required this.time,
      required this.isBlackListed});

  Logs.fromJson(Map<String, dynamic> json) {
    siteId = json['site_id'];
    siteName = json['site_name'];
    os = json['os'];
    browser = json['browser'];
    ip = json['ip'];
    time = json['time'];
    isBlackListed = json['is_black_listed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['site_id'] = siteId;
    data['site_name'] = siteName;
    data['os'] = os;
    data['browser'] = browser;
    data['ip'] = ip;
    data['time'] = time;
    data['is_black_listed'] = isBlackListed;
    return data;
  }
}
