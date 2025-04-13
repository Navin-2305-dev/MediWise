import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:mediwise/Health%20Mobile%20App/models/RTPlot.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  String temperature = "Fetching...";
  String heartRate = "Fetching...";
  String spo2 = "Fetching...";
  Timer? timer;
  final String esp32Url = 'http://172.16.4.241';

  // Heart rate chart data
  List<FlSpot> heartRateData = [];
  double time = 0.0;
  static const int maxDataPoints = 20;

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse(esp32Url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          temperature = "${data['temperature']} °C";
          heartRate = "${data['heart_rate']} bpm";
          spo2 = "${data['spo2']} %";

          // Update heart rate chart
          double hrValue =
              double.tryParse(data['heart_rate'].toString()) ?? 0.0;
          if (heartRateData.length >= maxDataPoints) {
            heartRateData.removeAt(0);
          }
          heartRateData.add(FlSpot(time, hrValue));
          time += 5.0; // Increment time by 5 seconds (matching refresh rate)
        });
      } else {
        setState(() {
          temperature = "Error";
          heartRate = "Error";
          spo2 = "Error";
        });
      }
    } catch (e) {
      setState(() {
        temperature = "N/A";
        heartRate = "N/A";
        spo2 = "N/A";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Health Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthScoreCard(),
              SizedBox(height: 16),
              RealTimeHeartRateChart(),
              SizedBox(height: 16),
              _buildSensorDataSection(),
              SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buildHealthMetricCard(
                      "Calories",
                      "210 kcal",
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildHealthMetricCard(
                      "Sleep",
                      "1h 23m",
                      Icons.nightlight_round,
                      Colors.blue,
                    ),
                    _buildHealthMetricCard(
                      "Walk",
                      "1.2 km",
                      Icons.directions_walk,
                      Colors.green,
                    ),
                    _buildHealthMetricCard(
                      "Heart Rate",
                      heartRate,
                      Icons.favorite,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthScoreCard() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Text(
                "84",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Health Score",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Based on your daily activities and sensor data",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Refresh Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Live Sensor Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.sensors, color: Colors.green),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSensorTile(
                  "Temperature", temperature, Icons.thermostat, Colors.red),
              _buildSensorTile("SpO2", spo2, Icons.water_drop, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorTile(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildHealthMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(value, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
