import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/screens/client/assesmnt/assessment.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key? key,
    required this.appt_id,
    required this.asmt_type,
  }) : super(key: key);
  final appt_id;
  final asmt_type;
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PageController controller = PageController();
  int index = 0;
  String instruction = '';
  bool combined = false;
  int asmtMaxScore = 0;
  int clientScore = 0;
  int assessmentSize = 0;
  List selecteddata = [];
  List assessmentdata = [];
  List assessmentdat = [];
  int assessmentIterValue = 0;
  bool multiassessment = false;
  bool multiassessmentonnext = false;
  bool multiassessmentonback = true;
  String? valueone;
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
    print(response.body);
    var resultsJson = json.decode(response.body) as Map;
    setState(() {
      combined = resultsJson['is_combined'];
      instruction = resultsJson['asmt_type_desc'];
      asmtMaxScore = resultsJson['asmt_max_score'];
      if (resultsJson['is_combined']) {
        assessmentSize = resultsJson['data'].length;
        assessmentIterValue = 0;
        print(assessmentSize);
        multiassessment = true;
        assessmentdata = resultsJson['data'];
        // print(assessmentdata);`
        this.selecteddata = resultsJson['data'][0]['selected'];
        this.makeSelected();
      } else {
        selecteddata = resultsJson['selected'];
        //(selecteddata);
        assessmentSize = resultsJson['data'].length;
        assessmentdata = resultsJson['data'];
        //assessmentdat = resultsJson['data']['question'];
        print(assessmentSize);
        // print("dataajhjhjhjhjhj");
        print(assessmentdata);

        // this.setDefault(this.selecteddata);
        makeSelected();
      }
    });
    return resultsJson;
  }

  makeSelected() {
    // tslint:disable-next-line:prefer-for-of
    // ignore: unnecessary_this
    for (int i = 0; i < selecteddata.length; i++) {
      // tslint:disable-next-line:prefer-for-of
      for (int j = 0; j < assessmentdata.length; j++) {
        if (assessmentdata[j].question.is_multiple_choice) {
          // tslint:disable-next-line:prefer-for-of
          for (int k = 0; k < assessmentdata[j].options.length; k++) {
            if (assessmentdata[j].options[k].id == selecteddata[i].id) {
              assessmentdata[j].options[k].selected = true;
              clientScore +=
                  assessmentdata[j].options[k].asmt_qn_opt_score as int;
            }
          }
        } else {
          if (assessmentdata[j].question.asmt_qn_id ==
              selecteddata[i].asmt_qn_opt_qn_id) {
            assessmentdata[j].answer = selecteddata[i].answer;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 105,
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 10,
                ),
                children: List.generate(
                  assessmentSize,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            this.index == index ? Colors.red : Colors.lightBlue,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    for (var i in assessmentdata)
                      Expanded(
                        child: PageView(
                          controller: controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                            assessmentSize,
                            (index) => Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i['questions'][index]['question']
                                        ['asmt_qn_name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // questions[index]['title'].forEach().
                                  // questions.forEach((element) { }).toList
                                  if (i['questions'][index]['question']
                                      ['is_multiple_choice'])
                                    Expanded(
                                      child: Column(
                                        children: i["questions"][index]
                                                ['options']
                                            .map<Widget>(
                                              (answer) => ListTile(
                                                onTap: () {
                                                  nextPage();
                                                },
                                                leading: Icon(Icons
                                                    .radio_button_off_rounded),
                                                title: Text(
                                                  answer.j['asmt_qn_opt_name'],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            onPressed: () {
                              previousPage();
                            },
                            child: Text(
                              'Previous',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.red[600],
                              ),
                            ),
                            onPressed: () {
                              nextPage();
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextPage() {
    if (index < assessmentSize) {
      setState(() {
        index++;
      });
      controller.jumpToPage(index);
      print(index);
    } else {
      Navigator.of(context).pop();
    }
  }

  void previousPage() {
    if (index > 0) {
      setState(() {
        index--;
      });
      controller.jumpToPage(index);
      print(index);
    }
  }
}
