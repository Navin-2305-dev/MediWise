import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class RealTimeHeartRateChart extends StatefulWidget {
  const RealTimeHeartRateChart({super.key});

  @override
  _RealTimeHeartRateChart createState() => _RealTimeHeartRateChart();
}

class _RealTimeHeartRateChart extends State<RealTimeHeartRateChart>
    with SingleTickerProviderStateMixin {
  late List<HeartRateData> chartData;
  late ChartSeriesController _chartSeriesController;
  late Timer _timer;
  late AnimationController _pulseController;
  int time = 0;
  double _baseHeartRate = 72.0; // Starting baseline heart rate
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    chartData = []; // Start with an empty dataset
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      enableMouseWheelZooming: true,
      zoomMode: ZoomMode.xy,
    );
    _timer = Timer.periodic(const Duration(seconds: 1),
        updateDataSource); // Slowed to 1-second updates
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        width: width * 0.9,
        height: height * 0.35,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SfCartesianChart(
            borderWidth: 0,
            title: ChartTitle(
              text: 'Real-Time Heart Rate Monitor  ❤️',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            zoomPanBehavior: _zoomPanBehavior,
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineType: TrackballLineType.vertical,
              tooltipSettings: const InteractiveTooltip(
                enable: true,
                color: Color(0xFFE91E63),
                textStyle: TextStyle(color: Colors.white),
              ),
              shouldAlwaysShow: true,
            ),
            series: <FastLineSeries<HeartRateData, int>>[
              FastLineSeries<HeartRateData, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: chartData,
                color: const Color(0xFFE91E63),
                width: 2.5,
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                xValueMapper: (HeartRateData data, _) => data.time,
                yValueMapper: (HeartRateData data, _) => data.heartRate,
                animationDuration: 0,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 6,
                  height: 6,
                  color: const Color(0xFFE91E63),
                  borderWidth: 2,
                  borderColor: Colors.white,
                ),
              ),
            ],
            primaryXAxis: NumericAxis(
              axisLine: const AxisLine(width: 1, color: Colors.grey),
              majorGridLines:
                  const MajorGridLines(width: 0.5, color: Colors.grey),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 5,
              labelStyle: const TextStyle(fontSize: 12, color: Colors.black54),
              title: AxisTitle(
                text: 'Time (seconds)',
                textStyle: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              minimum: time > 10 ? (time - 10).toDouble() : 0,
              maximum: time.toDouble() + 5,
            ),
            primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 1, color: Colors.grey),
              majorGridLines:
                  const MajorGridLines(width: 0.5, color: Colors.grey),
              majorTickLines: const MajorTickLines(size: 5, color: Colors.grey),
              interval: 10,
              minimum: 50,
              maximum: 110,
              labelStyle: const TextStyle(fontSize: 12, color: Colors.black54),
              title: AxisTitle(
                text: 'Heart Rate (BPM)',
                textStyle: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              plotBands: <PlotBand>[
                PlotBand(
                  start: 60,
                  end: 100,
                  color: Colors.green.withOpacity(0.1),
                  borderWidth: 1,
                  borderColor: Colors.green.withOpacity(0.3),
                  text: 'Normal',
                  textStyle: const TextStyle(color: Colors.green, fontSize: 12),
                  verticalTextAlignment: TextAnchor.end,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateDataSource(Timer timer) {
    // Generate ECG-like data mapped to BPM scale
    final newHeartRate = _generateECGSignal();
    chartData.add(HeartRateData(time++, newHeartRate));

    // Keep only the last 50 points to allow zooming
    if (chartData.length > 50) {
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );
    } else {
      _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1,
      );
    }

    // Occasionally adjust the baseline to simulate natural shifts
    if (time % 20 == 0) {
      _baseHeartRate =
          (_baseHeartRate + (math.Random().nextDouble() * 4 - 2)).clamp(65, 85);
    }

    setState(() {});
  }

  double _generateECGSignal() {
    final random = math.Random();
    final int cycleLength = 5; // Reduced cycle length for slower updates
    final int cyclePosition = time % cycleLength;

    // Simulate P wave, QRS complex, and T wave, mapped to BPM scale
    if (cyclePosition == 0) {
      return _baseHeartRate + 5 + random.nextDouble() * 2; // P wave
    } else if (cyclePosition == 1) {
      return _baseHeartRate - 5 + random.nextDouble() * 2; // Q dip
    } else if (cyclePosition == 2) {
      return _baseHeartRate +
          20 +
          random.nextDouble() * 5; // R peak (sharp spike)
    } else if (cyclePosition == 3) {
      return _baseHeartRate - 10 + random.nextDouble() * 2; // S dip
    } else if (cyclePosition == 4) {
      return _baseHeartRate + 10 + random.nextDouble() * 3; // T wave
    } else {
      return _baseHeartRate + random.nextDouble() * 2 - 1; // Baseline noise
    }
  }
}

class HeartRateData {
  HeartRateData(this.time, this.heartRate);
  final int time;
  final double heartRate;
}
