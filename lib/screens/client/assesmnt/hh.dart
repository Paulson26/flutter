// ignore_for_file: unnecessary_new, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Quiz1 extends StatefulWidget {
  const Quiz1({
    Key? key,
    required this.appt_id,
    required this.asmt_type,
  }) : super(key: key);
  final appt_id;
  final asmt_type;

  @override
  Quiz1State createState() => Quiz1State();
}

class Quiz1State extends State<Quiz1> {
  String option1 = '';
  String option2 = '';
  String option3 = '';
  List<String> options = [];
  List<int> selectedvalue = [];
  String instruction = '';
  bool combined = false;
  int asmtMaxScore = 0;
  int clientScore = 0;
  int assessmentSize = 1;
  List selecteddata = [];
  List assessmentdata = [];
  int assessmentdat = 0;
  int assessmentIterValue = 0;
  bool multiassessment = false;
  bool multiassessmentonnext = false;
  bool multiassessmentonback = true;
  String? valueone;
  late Future<List<Data>> fetchResult;
  @override
  void initState() {
    super.initState();

    fetchResult = fetchResultss();
  }

  // Future fetchResults() async {
  //   const storage = FlutterSecureStorage();
  //   var myJwt = await storage.read(key: "jwt");
  //   var clientid = await storage.read(key: "client_id");
  //   var cliniccode = await storage.read(key: "clinic_code");
  //   final uri = Uri.parse('http://10.0.2.2:8000/api/v1/getasmtQstns/')
  //       .replace(queryParameters: {
  //     'asmt_type': widget.asmt_type.toString(),
  //     'asmt_app_id': widget.appt_id.toString(),
  //   });
  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'JWT $myJwt',
  //       'clinic_code': '$cliniccode'
  //     },
  //   );
  //   print(response.body);
  //   var resultsJson = json.decode(response.body) as Map;
  //   setState(() {
  //     combined = resultsJson['is_combined'];
  //     instruction = resultsJson['asmt_type_desc'];
  //     asmtMaxScore = resultsJson['asmt_max_score'];
  //     if (resultsJson['is_combined']) {
  //       assessmentSize = resultsJson['data'].length;
  //       assessmentIterValue = 0;
  //       multiassessment = true;
  //       assessmentdata = resultsJson['data'];
  //       // print(assessmentdata);`
  //       this.selecteddata = resultsJson['data'][0]['selected'];
  //       this.makeSelected();
  //     } else {
  //       selecteddata = resultsJson['selected'];
  //       //(selecteddata);
  //       assessmentdata = resultsJson['data'];
  //       assessmentdat = resultsJson['data'][0]['question']['asmt_qn_id'];
  //       print(assessmentdat);
  //       // print("dataajhjhjhjhjhj");
  //       print(assessmentdata);

  //       // this.setDefault(this.selecteddata);
  //       makeSelected();
  //     }
  //   });
  //   return resultsJson;
  // }

  Future<List<Data>> fetchResultss() async {
    List<Data> list;
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/getasmtQstns/')
        .replace(queryParameters: {
      'asmt_type': widget.asmt_type.toString(),
      'asmt_app_id': widget.appt_id.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'JWT $myJwt',
      },
    );
    print(response.body);

    List jsonResponse = json.decode(response.body)['data'];
    // print(jsonResponse);
    return jsonResponse.map((doc) => Data.fromJson(doc)).toList();
    //print("List Size": list.length);
  }

  // makeSelected() {
  //   // tslint:disable-next-line:prefer-for-of
  //   // ignore: unnecessary_this
  //   for (int i = 0; i < selecteddata.length; i++) {
  //     // tslint:disable-next-line:prefer-for-of
  //     for (int j = 0; j < assessmentdata.length; j++) {
  //       if (assessmentdata[j].question.is_multiple_choice) {
  //         // tslint:disable-next-line:prefer-for-of
  //         for (int k = 0; k < assessmentdata[j].options.length; k++) {
  //           if (assessmentdata[j].options[k].id == selecteddata[i].id) {
  //             assessmentdata[j].options[k].selected = true;
  //             clientScore +=
  //                 assessmentdata[j].options[k].asmt_qn_opt_score as int;
  //           }
  //         }
  //       } else {
  //         if (assessmentdata[j].question.asmt_qn_id ==
  //             selecteddata[i].asmt_qn_opt_qn_id) {
  //           assessmentdata[j].answer = selecteddata[i].answer;
  //         }
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: fetchResult,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('No quizzes '),
              backgroundColor: Colors.green[700],
            ),
            backgroundColor: Colors.grey[100],
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Quizzes disponibles'),
              backgroundColor: Colors.green[700],
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                List<Data>? data = snapshot.data!;

                return RadioListTile<Data>(
                  value: data[index].options[index].asmtQnOptName as Data,
                  title: Text(
                    data[index].options[index].asmtQnOptName,
                  ),
                  onChanged: (val) => setState(() {
                    selectedvalue[index] = int.parse(val.toString());
                    //option1 = snapshot.data![index].asmtTypeDesc;
                    print(selectedvalue);
                    print(option1);
                  }),
                  groupValue: selectedvalue[index] as Data,
                );
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('No hay quizzes publicados'),
              backgroundColor: Colors.green[700],
            ),
            backgroundColor: Colors.grey[100],
          );
        }
      },
    );
  }
}

class Data {
  Data({
    required this.question,
    required this.options,
  });
  late final List<Question> question;
  late final List<Options> options;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      question: json['question'],
      options: json['options'],
    );
  }
}

class Question {
  Question({
    required this.asmtQnId,
    required this.asmtQnName,
    required this.asmtQnDesc,
    required this.isMultipleChoice,
  });
  late final int asmtQnId;
  late final String asmtQnName;
  late final String asmtQnDesc;
  late final bool isMultipleChoice;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        asmtQnId: json['asmt_qn_id'],
        asmtQnName: json['asmt_qn_name'],
        asmtQnDesc: json['asmt_qn_desc:'],
        isMultipleChoice: json['is_multiple_choice']);
  }
}

class Options {
  Options({
    required this.id,
    required this.asmtQnOptName,
    required this.asmtQnOptQnId,
    required this.asmtQnOptScore,
    required this.selected,
  });
  late final int id;
  late final String asmtQnOptName;
  late final int asmtQnOptQnId;
  late final int asmtQnOptScore;
  late final bool selected;

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
        id: json['id'],
        asmtQnOptName: json['asmt_qn_opt_name'],
        asmtQnOptQnId: json['asmt_qn_opt_qn_id'],
        asmtQnOptScore: json['asmt_qn_opt_score'],
        selected: json['selected']);
  }
}
