import 'package:flutter/material.dart';
import 'package:nirikshan_recon/models/dump_response.dart';
import 'package:nirikshan_recon/pages/base_url.dart';
import 'package:nirikshan_recon/utils/api_client.dart';
import 'package:nirikshan_recon/utils/colors.dart';
import 'package:nirikshan_recon/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  DumpResponse? dumpResponse;
  List<ChartData>? chartData;
  String? userName;

  _getDumpData(String site) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('name');
    String? jwtToken = prefs.getString('token');
    String? baseUrl = prefs.getString('base');
    ApiClient apiClient = ApiClient(jwtToken, baseUrl!);
    var data = await apiClient.getDumpData(site);
    var blackLists = data.data.blacklistLength;
    var total = data.data.totalLength;
    var whiteLists = total - blackLists;
    var blackPercentage = (blackLists / total) * 100;
    var whitePercentage = (whiteLists / total) * 100;
    ChartData blackData = ChartData("Blacklisted requests", blackPercentage);
    ChartData whiteData = ChartData("Whitelisted requests", whitePercentage);
    List<ChartData> chartDataList = [blackData, whiteData];
    setState(() {
      userName = username;
      chartData = chartDataList;
      dumpResponse = data;
    });
    return data;
  }

  String _convTime(String date) {
    var dateTime = DateTime.parse(date);
    return convertToAgo(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _getDumpData("google");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyThemeColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleThemeColor,
        elevation: 20,
        foregroundColor: Colors.white,
        onPressed: () {
          _getDumpData("google");
        },
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _header(),
            chartData == null ? const CircularProgressIndicator() : _card(),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                maxChildSize: 0.97,
                minChildSize: 0.5,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: purpleThemeColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: dumpResponse == null
                        ? const CircularProgressIndicator()
                        : _buildList(
                            scrollController,
                            dumpResponse!.data.logs.reversed.toList(),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(ScrollController scrollController, List<Logs> logs) {
    return ListView.builder(
      itemCount: logs.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            onTap: () {
              _showBottomModalSheet(context, logs[index]);
            },
            child: Card(
              color: greyThemeColor,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_convTime(logs[index].time)),
                    Text(logs[index].ip),
                    logs[index].isBlackListed
                        ? const Icon(Icons.block, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(top: 16, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Hello $userName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const UrlInputPage(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 72),
      child: Card(
        color: purpleThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 250,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: const Text(
                  "Statistics for WebServer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: SfCircularChart(
                    onDataLabelRender: (DataLabelRenderArgs args) =>
                        const DataLabelSettings(
                      textStyle: TextStyle(
                        color: greyThemeColor,
                        fontSize: 12,
                      ),
                    ),
                    legend: Legend(isVisible: true),
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<ChartData, String>(
                          dataLabelMapper: (ChartData data, _) =>
                              "${data.y.toStringAsFixed(2)} %",
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showBottomModalSheet(BuildContext context, Logs data) async {
  String _dateFormat(String date) {
    var dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  return await showModalBottomSheet<void>(
      context: context,
      backgroundColor: greyThemeColor,
      builder: (BuildContext ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                "Log data of Server Request",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 250,
              child: Card(
                child: SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("IP: ${data.ip}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Browser : ${data.browser}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("OS : ${data.os}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Is Blacklisted Request? : ${data.isBlackListed}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Time of request : ${_dateFormat(data.time)}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      });
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
