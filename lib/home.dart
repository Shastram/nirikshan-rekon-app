import 'package:flutter/material.dart';
import 'package:nirikshan_recon/models/dump_response.dart';
import 'package:nirikshan_recon/utils/api_client.dart';
import 'package:nirikshan_recon/utils/helpers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  ApiClient apiClient = ApiClient(
    "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MzczOTQ2MjMsImlhdCI6MTYzNzMwODIyMywidWlkIjoiNjE5NjdiYmI3N2M1NjZkY2YwOTY5OTg2IiwidXNlcm5hbWUiOiJhZG1pbiJ9.ScYsAlch8mVVUsKy6kdqz9FXKmAcaYoBHVuEf4gAKbHfNSoD4INkrTd9joEHnDRZO3n-A363tnJfPUEdKeeaVQ",
    "http://192.168.1.4:3000",
  );
  DumpResponse? dumpResponse;

  _getDumpData(String site) async {
    var data = await apiClient.getDumpData(site);
    setState(() {
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
      body: SafeArea(
        child: Stack(
          children: [
            _header(),
            _card(),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                maxChildSize: 0.97,
                minChildSize: 0.5,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: dumpResponse == null
                        ? const CircularProgressIndicator()
                        : _buildList(scrollController, dumpResponse!.data.logs),
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
          child: Card(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_convTime(logs[index].time)),
                  Text(logs[index].ip),
                  logs[index].isBlackListed
                      ? const Icon(Icons.block)
                      : const Icon(Icons.check),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              "Hello User",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 64),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 150,
          child: Center(
            child: SfCircularChart(
              legend: Legend(isVisible: true),
              series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
