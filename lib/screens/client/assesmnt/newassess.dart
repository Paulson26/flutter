// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:my_thera/screens/messagedialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AssessmentDetail extends StatefulWidget {
  const AssessmentDetail({
    Key? key,
    required this.asmt_app_id,
    required this.appt_id,
    required this.asmt_type,
  }) : super(key: key);
  final appt_id;
  final asmt_type;
  final asmt_app_id;

  @override
  State<AssessmentDetail> createState() => _AssessmentDetailState();
}

class _AssessmentDetailState extends State<AssessmentDetail> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  String instruction = '';
  int asmtMaxScore = 0;
  int clientScore = 0;
  int assessmentSize = 1;
  List selecteddata = [];
  List assessmentdata = [];
  int assessmentIterValue = 0;
  bool multiassessment = false;
  bool multiassessmentonnext = false;
  bool multiassessmentonback = true;
  List savedata = [];
  List temp = [];
  List asmt = [];
  List saveMultidata = [];
  String? valueone;
  String? valuetwo;
  var temp1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchResults();
    });
  }

  Future fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
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
        'clinic_code': '$cliniccode'
      },
    );
    var resultsJson = json.decode(response.body);
    setState(() {
      instruction = resultsJson['asmt_type_desc'];
      asmtMaxScore = resultsJson['asmt_max_score'];
      if (resultsJson['is_combined']) {
        assessmentSize = resultsJson['data'].length;
        assessmentIterValue = 0;
        multiassessment = true;
        assessmentdata = resultsJson['data'];
      } else {
        assessmentSize = resultsJson['data'].length;
        selecteddata = resultsJson['selected'];
        assessmentdata = resultsJson['data'];
        multiassessment = false;

        // this.setDefault(this.selecteddata);
        //makeSelected();
      }
    });
    return resultsJson;
  }

  makeSelected() {
    for (var i = 0; i < selecteddata.length; i++) {
      for (var j = 0; j < assessmentdata.length; j++) {
        if (assessmentdata[j]['question']['is_multiple_choice']) {
          for (var k = 0; k < assessmentdata[j]['options'].length; k++) {
            if (assessmentdata[j]['options'][k]['id'].toString() ==
                selecteddata[i]['id'].toString()) {
              assessmentdata[j]['options'][k]['selected'] = true;
              clientScore +=
                  assessmentdata[j]['options'][k]['asmt_qn_opt_score'] as int;
            }
          }
        } else {
          if (assessmentdata[j]['question']['asmt_qn_id'] ==
              selecteddata[i]['asmt_qn_opt_qn_id']) {
            assessmentdata[j]['answer'] = selecteddata[i]['answer'];
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (multiassessment == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Assessments"),
          ),
          body: SingleChildScrollView(
            child: (Column(
              children: [
                Container(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      shadowColor: Colors.green,
                      margin: const EdgeInsets.all(20),
                      child: Column(children: [
                        ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title: const Text('Instructions'),
                          subtitle: Text(
                            instruction,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Each assessment have a score. The Score Points are explained in the respective section. \n\n Session One(Four Option Type)[Max Score :Three] \n Session Two(YES/No Type)[Max Score : One] \n Session Three(Descriptive Type)[Max Score Zero]',
                            style: TextStyle(
                                color: Colors.black54.withOpacity(0.6)),
                          ),
                        )
                      ])),
                ),
                Form(
                    key: _oFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        for (var i = 0; i < assessmentdata.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Table(
                              border: TableBorder.all(
                                  color:
                                      const Color.fromARGB(255, 209, 207, 207)),
                              // border: const TableBorder(
                              //     bottom: BorderSide(),
                              //     horizontalInside: BorderSide()),
                              children: [
                                TableRow(children: [
                                  Text(" " +
                                      (i + 1).toString() +
                                      ". " +
                                      (assessmentdata[i]['question']
                                          ['asmt_qn_name'])),
                                  if (assessmentdata[i]['question']
                                          ['is_multiple_choice'] &&
                                      assessmentdata[i]['options'].length >= 1)
                                    Column(
                                      children: [
                                        for (var j = 0;
                                            j <
                                                assessmentdata[i]['options']
                                                    .length;
                                            j++)
                                          ListTile(
                                            title: Text(assessmentdata[i]
                                                    ['options'][j]
                                                ['asmt_qn_opt_name']),
                                            leading: Radio<dynamic>(
                                                value: assessmentdata[i]
                                                            ['options'][j]
                                                        ['asmt_qn_opt_name']
                                                    .toString(),
                                                groupValue: assessmentdata[i]
                                                            ['options'][j]
                                                        ['asmt_qn_opt_qn_id']
                                                    .toString(),
                                                onChanged: (value) {
                                                  for (var j = 0;
                                                      j <
                                                          assessmentdata[i]
                                                                  ['options']
                                                              .length;
                                                      j++) {
                                                    setState(() {
                                                      assessmentdata[i]
                                                                  ['options'][j]
                                                              [
                                                              'asmt_qn_opt_qn_id'] =
                                                          value.toString();
                                                      //print(valuetwo);
                                                    });
                                                  }

                                                  savedata.add({
                                                    'asmt_result_qn_id':
                                                        assessmentdata[i]
                                                                ['question']
                                                            ['asmt_qn_id'],
                                                    'asmt_result_option_id':
                                                        assessmentdata[i]
                                                            ['options'][j]['id']
                                                  });

                                                  //print(savedata);
                                                }),
                                          ),
                                      ],
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            maxLines: 5,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Notes"),
                                            onSaved: (String? value) {
                                              setState(() {
                                                savedata.add({
                                                  'asmt_result_qn_id':
                                                      assessmentdata[i]
                                                              ['question']
                                                          ['asmt_qn_id'],
                                                  'asmt_result_answer': value
                                                });
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                ])
                              ],
                            ),
                          )
                      ]),
                    )),
                const SizedBox(height: 20),
                Container(
                    width: 200,
                    height: 50.0,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_oFormKey.currentState!.validate()) {
                          _oFormKey.currentState!.save();

                          print(savedata);

                          const storage = FlutterSecureStorage();

                          var myJwt = await storage.read(key: "jwt");
                          var clientid = await storage.read(key: "client_id");
                          print(clientid);
                          var cliniccode =
                              await storage.read(key: "clinic_code");
                          print(cliniccode);
                          if (multiassessment) {
                            var url = '/saveCombinedAsmt/';
                            List assessmentop = [];
                          } else {
                            const clinicianScore = 0;

                            final uri = Uri.parse(
                                'http://10.0.2.2:8000/api/v1/saveAssessment/');
                            final response = await http.post(
                              uri,
                              headers: {
                                'Accept': 'application/json',
                                'Content-Type': 'application/json',
                                'Authorization': 'JWT $myJwt',
                                'clinic_code': '$cliniccode'
                              },
                              body: jsonEncode({
                                "asmt_appt_id": widget.appt_id,
                                "asmt_client_id": clientid,
                                "clinic_code": cliniccode,
                                "asmt_type": widget.asmt_type,
                                "data": savedata,
                                "asmt_clinician_score": '',
                                "note": ''
                              }),
                              encoding: Encoding.getByName("utf-8"),
                            );
                            final responseJson = json.decode(response.body);
                            print(responseJson['message']);
                            if (response.statusCode == 200) {
                              final responseJson = json.decode(response.body);
                              print(responseJson);
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Appointment Status",
                                desc: "Assessment submitted successfully.",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/dashboard'),
                                    width: 120,
                                  )
                                ],
                              ).show();
                              //Navigator.pushNamed(context, '/dashboard');
                              toast("${responseJson['message']}");
                            } else {
                              throw Exception('Failed to load api');
                            }
                          }
                        }
                      },
                      child: const Center(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Combined Assessments"),
          ),
          body: SingleChildScrollView(
            child: (Column(
              children: [
                Container(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      shadowColor: Colors.green,
                      margin: const EdgeInsets.all(20),
                      child: Column(children: [
                        const ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title: Text('Instructions'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Each assessment have a score. The Score Points are explained in the respective section. \n\n Session One(Four Option Type)[Max Score :Three] \n Session Two(YES/No Type)[Max Score : One] \n Session Three(Descriptive Type)[Max Score Zero]',
                            style: TextStyle(
                                color: Colors.black54.withOpacity(0.6)),
                          ),
                        )
                      ])),
                ),
                Form(
                    key: _oFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        for (var i = 0; i < assessmentdata.length; i++)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Flexible(
                                      child: Text(
                                        (i + 1).toString() +
                                            "." +
                                            assessmentdata[i]['asmt_name'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Table(
                                  border: TableBorder.all(
                                      color: const Color.fromARGB(
                                          255, 209, 207, 207)),
                                  children: [
                                    for (var j = 0;
                                        j <
                                            assessmentdata[i]['questions']
                                                .length;
                                        j++)
                                      TableRow(children: [
                                        Text(" " +
                                            (j + 1).toString() +
                                            ". " +
                                            (assessmentdata[i]['questions'][j]
                                                ['question']['asmt_qn_name'])),
                                        if (assessmentdata[i]['questions'][j]
                                                    ['question']
                                                ['is_multiple_choice'] &&
                                            assessmentdata[i]['questions'][j]
                                                        ['options']
                                                    .length >=
                                                1)
                                          Column(
                                            children: [
                                              for (var k = 0;
                                                  k <
                                                      assessmentdata[i]
                                                                  ['questions']
                                                              [j]['options']
                                                          .length;
                                                  k++)
                                                ListTile(
                                                  title: Text(assessmentdata[i]
                                                              ['questions'][j]
                                                          ['options'][k]
                                                      ['asmt_qn_opt_name']),
                                                  leading: Radio<dynamic>(
                                                      value: assessmentdata[i]
                                                                      ['questions'][j]
                                                                  ['options'][k]
                                                              [
                                                              'asmt_qn_opt_name']
                                                          .toString(),
                                                      groupValue: assessmentdata[
                                                                          i]
                                                                      ['questions'][j]
                                                                  ['options'][k]
                                                              ['asmt_qn_opt_qn_id']
                                                          .toString(),
                                                      onChanged: (value) {
                                                        for (var k = 0;
                                                            k <
                                                                assessmentdata[i]
                                                                            [
                                                                            'questions'][j]
                                                                        [
                                                                        'options']
                                                                    .length;
                                                            k++) {
                                                          setState(() {
                                                            assessmentdata[i]['questions']
                                                                            [j][
                                                                        'options'][k]
                                                                    [
                                                                    'asmt_qn_opt_qn_id'] =
                                                                value
                                                                    .toString();
                                                            //print(valuetwo);
                                                          });
                                                        }
                                                        setState(() {
                                                          savedata.add({
                                                            'asmt_type':
                                                                assessmentdata[
                                                                        i][
                                                                    'asmt_type'],
                                                            'data': ({
                                                              'asmt_result_qn_id':
                                                                  assessmentdata[i]['questions']
                                                                              [
                                                                              j]
                                                                          [
                                                                          'question']
                                                                      [
                                                                      'asmt_qn_id'],
                                                              'asmt_result_option_id':
                                                                  assessmentdata[
                                                                              i]
                                                                          [
                                                                          'questions'][j]
                                                                      [
                                                                      'options'][k]['id']
                                                            })
                                                          });
                                                        });
                                                      }),
                                                ),
                                            ],
                                          )
                                        else
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  maxLines: 5,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: "Notes"),
                                                  onSaved: (String? value) {
                                                    setState(() {
                                                      savedata.add({
                                                        'asmt_type':
                                                            assessmentdata[i]
                                                                ['asmt_type'],
                                                        'data': ({
                                                          'asmt_result_qn_id':
                                                              assessmentdata[i][
                                                                          'questions'][j]
                                                                      [
                                                                      'question']
                                                                  [
                                                                  'asmt_qn_id'],
                                                          'asmt_result_answer':
                                                              value.toString()
                                                        })
                                                      });
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                      ])
                                  ],
                                ),
                              ),
                            ],
                          )
                      ]),
                    )),
                const SizedBox(height: 20),
                Container(
                    width: 200,
                    height: 50.0,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_oFormKey.currentState!.validate()) {
                          _oFormKey.currentState!.save();
                          List save1 = [];
                          List save2 = [];
                          for (var i = 0; i < assessmentdata.length; i++) {
                            for (var j = 0; j < savedata.length; j++) {
                              if (assessmentdata[i]['asmt_type'].toString() ==
                                  savedata[j]['asmt_type'].toString())
                                save1.add(
                                  savedata[j]['data'],
                                );
                            }
                            save2.add({
                              'asmt_type':
                                  assessmentdata[i]['asmt_type'].toString(),
                              'data': save1
                            });
                          }
                          const storage = FlutterSecureStorage();

                          var myJwt = await storage.read(key: "jwt");
                          var clientid = await storage.read(key: "client_id");
                          var cliniccode =
                              await storage.read(key: "clinic_code");

                          final uri = Uri.parse(
                              'http://10.0.2.2:8000/api/v1/saveCombinedAsmt/');
                          final response = await http.post(
                            uri,
                            headers: {
                              'Accept': 'application/json',
                              'Content-Type': 'application/json',
                              'Authorization': 'JWT $myJwt',
                              'clinic_code': '$cliniccode'
                            },
                            body: jsonEncode({
                              "asmt_appt_id": widget.appt_id,
                              "asmt_client_id": clientid,
                              "clinic_code": cliniccode,
                              "asmt_type": widget.asmt_type,
                              "data": save2,
                              "asmt_clinician_score": '',
                              "note": ''
                            }),
                            encoding: Encoding.getByName("utf-8"),
                          );

                          if (response.statusCode == 200) {
                            Alert(
                              context: context,
                              type: AlertType.success,
                              title: "Appointment Status",
                              desc: "Assessment submitted successfully.",
                              buttons: [
                                DialogButton(
                                  child: const Text(
                                    "ok",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/dashboard'),
                                  width: 120,
                                )
                              ],
                            ).show();
                          } else {
                            throw Exception('Failed to load api');
                          }
                        }
                      },
                      child: const Center(
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
          ));
      //MaterialApp
    }
  }

  void nextPage() {}
  void previousPage() {}
}
