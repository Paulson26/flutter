// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:my_thera/screens/client/graphs/modeljj.dart';
import 'package:my_thera/screens/client/graphs/kk.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class Chart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Chart({Key? key}) : super(key: key);

  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  var date;
  var clientprgrs;
  var clinicianprog;
  var q;
  var w;
  var t;
  List p = [];
  List pro = [];
  List dat = [];
  List xa = [];
  List progress = [];
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;
  int e = 0;
  int f = 0;
  int g = 0;
  Future fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/get-mental-status/')
        .replace(queryParameters: {
      'client_id': clientid.toString(),
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    var resultsJson = json.decode(response.body)['data'];
    setState(() {
      var xaxis = resultsJson['xAxis'];
      var yaxis = resultsJson['yAxis'];
      for (var i = 0; i < xaxis.length; i++) {
        for (var j = 0; j < yaxis.length; j++) {
          xa.add({'x': xaxis[i], 'y': yaxis[j]});
          i++;
        }
      }
      a = xa[0]['y'];
      b = xa[1]['y'];
      c = xa[2]['y'];
      d = xa[3]['y'];
      e = xa[4]['y'];
      f = xa[5]['y'];
      g = xa[6]['y'];
    });

    return resultsJson;
  }

  Future fetchProgress() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var cliniccode = await storage.read(key: "clinic_code");
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/get-client-progress/')
        .replace(queryParameters: {
      'client_id': clientid.toString(),
    });
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
        'clinic_code': '$cliniccode'
      },
    );
    var results = json.decode(response.body);
    print(results);
    setState(() {
      progress.add({
        date = results['data']['xAxis'],
        clientprgrs = results['data']['yAxisClient'],
        clinicianprog = results['data']['yAxisClinician'],
      });

      for (var j = 0; j < date.length; j++) {
        dat.add({
          'x': date[j],
        });
      }
      for (var j = 0; j < clientprgrs.length; j++) {
        p.add({
          'y': date[j],
        });
      }
      for (var j = 0; j < clinicianprog.length; j++) {
        pro.add({'z': clinicianprog[j]});
      }
    });
    q = dat[0]['x'].toString();

    if (p.isEmpty) {
      w = 0;
    } else {
      w = p[0]['x'];
    }
    t = pro[0]['z'];
    print(q);
    return results;
  }

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    fetchResults();
    fetchProgress();
    super.initState();
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            _buildDefaultColumnChart(),
            const SizedBox(
              height: 0,
            ),
            const Center(
              child: Text('Mental Status',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            // const SizedBox(
            //   height: 60,
            // ),
            // _buildDefaultColumnCharts(),
            // const SizedBox(
            //   height: 10,
            // ),
            // Center(
            //   child:
            //       Text(q, style: const TextStyle(fontWeight: FontWeight.bold)),
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            // const Center(
            //   child: Text('Client Progress',
            //       style: TextStyle(fontWeight: FontWeight.bold)),
            // ),
            // const SizedBox(
            //   height: 60,
            // ),
          ],
        ),
      ),
    );
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  // SfCartesianChart _buildDefaultColumnCharts() {
  //   return SfCartesianChart(
  //     plotAreaBorderWidth: 0,
  //     primaryXAxis: CategoryAxis(
  //       majorGridLines: const MajorGridLines(width: 0),
  //     ),
  //     primaryYAxis: NumericAxis(
  //         axisLine: const AxisLine(width: 0),
  //         labelFormat: '{value}',
  //         majorTickLines: const MajorTickLines(size: 0)),
  //     series: _getDefaultColumnSerie(),
  //     tooltipBehavior: _tooltipBehavior,
  //   );
  // }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Depression', y: a.toDouble()),
          ChartSampleData(x: 'Anxiety', y: b.toDouble()),
          ChartSampleData(x: 'Obsessive', y: c.toDouble()),
          ChartSampleData(x: 'Sleep', y: d.toDouble()),
          ChartSampleData(x: 'Unfocused', y: e.toDouble()),
          ChartSampleData(x: 'Impluse', y: f.toDouble()),
          ChartSampleData(x: 'Suicidal', y: g.toDouble()),
        ],
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 12)),
      )
    ];
  }

  // List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSerie() {
  //   return <ColumnSeries<ChartSampleData, String>>[
  //     ColumnSeries<ChartSampleData, String>(
  //       dataSource: <ChartSampleData>[
  //         ChartSampleData(x: 'Client Progress', y: w),
  //         ChartSampleData(x: 'Clinician Progress', y: t),
  //       ],
  //       xValueMapper: (ChartSampleData sales, _) => sales.x,
  //       yValueMapper: (ChartSampleData sales, _) => sales.y,
  //       dataLabelSettings: const DataLabelSettings(
  //           isVisible: true, textStyle: TextStyle(fontSize: 12)),
  //     )
  //   ];
  // }
}
