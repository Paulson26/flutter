// import 'dart:convert';
// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:http/http.dart' as http;
// import 'package:my_thera/screens/bottom_navigation.dart';

// class AssessmentDetails extends StatefulWidget {
//   const AssessmentDetails({
//     Key? key,
//     required this.appt_id,
//     required this.asmt_type,
//   }) : super(key: key);
//   final appt_id;
//   final asmt_type;

//   @override
//   State<AssessmentDetails> createState() => _AssessmentDetailsState();
// }

// class _AssessmentDetailsState extends State<AssessmentDetails> {
//   String instruction = '';
//   bool combined = false;
//   int asmtMaxScore = 0;
//   int index = 0;
//   int clientScore = 0;
//   int assessmentSize = 1;
//   List selecteddata = [];
//   List assessmentdata = [];
//   int assessmentdat = 0;
//   int assessmentIterValue = 0;
//   bool multiassessment = false;
//   bool multiassessmentonnext = false;
//   bool multiassessmentonback = true;
//   String? valueone;

//   @override
//   void initState() {
//     super.initState();

//     fetchResults();
//   }

//   Future fetchResults() async {
//     const storage = FlutterSecureStorage();
//     var myJwt = await storage.read(key: "jwt");
//     var clientid = await storage.read(key: "client_id");
//     var cliniccode = await storage.read(key: "clinic_code");
//     final uri = Uri.parse('http://10.0.2.2:8000/api/v1/getasmtQstns/')
//         .replace(queryParameters: {
//       'asmt_type': widget.asmt_type.toString(),
//       'asmt_app_id': widget.appt_id.toString(),
//     });
//     final response = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'JWT $myJwt',
//         'clinic_code': '$cliniccode'
//       },
//     );
//     print(response.body);
//     var resultsJson = json.decode(response.body) as Map;
//     setState(() {
//       combined = resultsJson['is_combined'];
//       instruction = resultsJson['asmt_type_desc'];
//       asmtMaxScore = resultsJson['asmt_max_score'];
//       if (resultsJson['is_combined']) {
//         assessmentSize = resultsJson['data'].length;
//         assessmentIterValue = 0;
//         multiassessment = true;
//         assessmentdata = resultsJson['data'];
//         // print(assessmentdata);`
//         this.selecteddata = resultsJson['data'][0]['selected'];
//         this.makeSelected();
//       } else {
//         selecteddata = resultsJson['selected'];
//         //(selecteddata);
//         assessmentdata = resultsJson['data'];
//         assessmentdat = resultsJson['data'][0]['question']['asmt_qn_id'];
//         print(assessmentdat);
//         // print("dataajhjhjhjhjhj");
//         print(assessmentdata);

//         // this.setDefault(this.selecteddata);
//         makeSelected();
//       }
//     });
//     return resultsJson;
//   }

//   makeSelected() {
//     // tslint:disable-next-line:prefer-for-of
//     // ignore: unnecessary_this
//     for (int i = 0; i < selecteddata.length; i++) {
//       // tslint:disable-next-line:prefer-for-of
//       for (int j = 0; j < assessmentdata.length; j++) {
//         if (assessmentdata[j].question.is_multiple_choice) {
//           // tslint:disable-next-line:prefer-for-of
//           for (int k = 0; k < assessmentdata[j].options.length; k++) {
//             if (assessmentdata[j].options[k].id == selecteddata[i].id) {
//               assessmentdata[j].options[k].selected = true;
//               clientScore +=
//                   assessmentdata[j].options[k].asmt_qn_opt_score as int;
//             }
//           }
//         } else {
//           if (assessmentdata[j].question.asmt_qn_id ==
//               selecteddata[i].asmt_qn_opt_qn_id) {
//             assessmentdata[j].answer = selecteddata[i].answer;
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Assesments"),
//         ),
//         body: SingleChildScrollView(
//           child: (Column(
//             children: [
//               Container(
//                 child: Card(
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 8,
//                     shadowColor: Colors.green,
//                     margin: EdgeInsets.all(20),
//                     child: Column(children: [
//                       ListTile(
//                         // leading: Icon(Icons.arrow_drop_down_circle),
//                         title: const Text('Instructions'),
//                         subtitle: Text(
//                           instruction,
//                           style:
//                               TextStyle(color: Colors.black.withOpacity(0.6)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           'Each assessment have a score. The Score Points are explained in the respective section. \n\n Session One(Four Option Type)[Max Score :Three] \n Session Two(YES/No Type)[Max Score : One] \n Session Three(Descriptive Type)[Max Score Zero]',
//                           style:
//                               TextStyle(color: Colors.black54.withOpacity(0.6)),
//                         ),
//                       )
//                     ])),
//               ),
//               Column(children: [
//                 //if (combined == true)
//                 for (var i in assessmentdata)
//                   Table(
//                     border: TableBorder(
//                         horizontalInside: BorderSide(
//                             width: 1,
//                             color: Colors.black,
//                             style: BorderStyle.solid)),
//                     children: [
//                       //if (i['is_combined'])
//                       TableRow(children: [
//                         Text(i['question']['asmt_qn_name']),
//                         if (i['question']['is_multiple_choice'])
//                           Column(
//                             children: [
//                               // ignore: unused_local_variable
//                               //for (var k in assessmentdat)
//                               for (var j in i['options'])
//                                 //for (var j in i['options'])
//                                 ListTile(
//                                   title: Text(j['asmt_qn_opt_name']),
//                                   leading: Radio<dynamic>(
//                                     value: j['asmt_qn_opt_name'],
//                                     groupValue: j['asmt_qn_opt_qn_id'],
//                                     onChanged: (value) {
//                                       setState(() {
//                                         // this.makeSelected();
//                                         for (var j in i['options']) {
//                                           j['asmt_qn_opt_qn_id'] = value;
//                                         }
//                                         // selecteddata.add(value);
//                                       });
//                                       selecteddata.add(
//                                         j['asmt_qn_opt_qn_id'],
//                                       );
//                                       print(selecteddata);
//                                     },
//                                   ),
//                                   // onTap: () {
//                                   //   setState(() {
//                                   //     //valueone = value.toString();
//                                   //     selecteddata.add(valueone);
//                                   //     print(selecteddata);
//                                   //     index = index + 1;
//                                   //   });
//                                   // },
//                                 ),
//                             ],
//                           )
//                         else
//                           TextFormField(
//                             maxLines: 5,
//                             decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: "Notes"),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter some text';
//                               }
//                               return null;
//                             },
//                           ),
//                       ])
//                     ],
//                   )
//               ]),
//               Container(
//                   padding: const EdgeInsets.only(right: 300.0, top: 40.0),
//                   child: ElevatedButton(
//                     onPressed: () async {
// //                     if(assessmentSize == (assessmentIterValue + 1)){
// //                       const storage = FlutterSecureStorage();
// //                       var cliniccode = await storage.read(key: "clinic_code");
// //                           if (multiassessment) {
// //       var url = '/saveCombinedAsmt/';
// //       List assessmentop = [];
// //       assessmentop.forEach(|(mainelement) => {
// //         //const savedataMulti = [];
// //         mainelement.questions.forEach(element => {
// //           if (!element.question.is_multiple_choice) {
// //             savedataMulti.push({ asmt_result_qn_id: element.question.asmt_qn_id, asmt_result_answer: element.answer });
// //           } else {
// //             element.options.forEach(op => {
// //               if (op.selected) {
// //                 savedataMulti.push({ asmt_result_qn_id: op.asmt_qn_opt_qn_id, asmt_result_option_id: op.id });

// //               }

// //             });
// //           }

// //         });
// //         const temp = {asmt_type: mainelement.asmt_type, data: savedataMulti};
// //         this.savedata.push(temp);
// //       });

// //     } else {
// //       String url = '/saveAssessment/';
// //       const clinicianScore = 0;
// //       assessmentdata.forEach(Map
// //        element => {
// //         if (!element['question']['is_multiple_choice']) {
// //           this.savedata.push({ asmt_result_qn_id: element.question.asmt_qn_id, asmt_result_answer: element.answer });
// //         } else {
// //           element.options.forEach(op => {
// //             if (op.selected) {
// //               this.savedata.push({ asmt_result_qn_id: op.asmt_qn_opt_qn_id, asmt_result_option_id: op.id });
// //               this.clinicianScore += op.asmt_qn_opt_score;
// //             }

// //           });
// //         }

// //       });
// //     }

// //     this.payload = {
// //       asmt_appt_id: this.asmtAppId,
// //       asmt_client_id: this.clientId,
// //       clinic_code: cliniccode,
// //       asmt_type: this.asmtType,
// //       data: this.savedata,
// //       asmt_clinician_score: '',
// //       note: ''
// //     };

// //  else {
// //       this.addAssessmentDetails();
// //     }

// //                     }
//                     },
//                     child: Text('Submit'),
//                   ))
//             ],
//           )),
//         ));
//   }
// }

// class Assessment {
//   Assessment({
//     required this.status,
//     required this.isCombined,
//     required this.asmtTypeDesc,
//     required this.data,
//     required this.selected,
//     required this.asmtMaxScore,
//   });
//   late final String status;
//   late final bool isCombined;
//   late final String asmtTypeDesc;
//   late final List<Data> data;
//   late final List<dynamic> selected;
//   late final int asmtMaxScore;

//   Assessment.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     isCombined = json['is_combined'];
//     asmtTypeDesc = json['asmt_type_desc'];
//     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
//     selected = List.castFrom<dynamic, dynamic>(json['selected']);
//     asmtMaxScore = json['asmt_max_score'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['is_combined'] = isCombined;
//     _data['asmt_type_desc'] = asmtTypeDesc;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     _data['selected'] = selected;
//     _data['asmt_max_score'] = asmtMaxScore;
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.question,
//     required this.options,
//   });
//   late final Question question;
//   late final List<Options> options;

//   Data.fromJson(Map<String, dynamic> json) {
//     question = Question.fromJson(json['question']);
//     options = json['options'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['question'] = question.toJson();
//     _data['options'] = options;
//     return _data;
//   }
// }

// class Question {
//   Question({
//     required this.asmtQnId,
//     required this.asmtQnName,
//     this.asmtQnDesc,
//     required this.isMultipleChoice,
//   });
//   late final int asmtQnId;
//   late final String asmtQnName;
//   late final Null asmtQnDesc;
//   late final bool isMultipleChoice;

//   Question.fromJson(Map<String, dynamic> json) {
//     asmtQnId = json['asmt_qn_id'];
//     asmtQnName = json['asmt_qn_name'];
//     asmtQnDesc = null;
//     isMultipleChoice = json['is_multiple_choice'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['asmt_qn_id'] = asmtQnId;
//     _data['asmt_qn_name'] = asmtQnName;
//     _data['asmt_qn_desc'] = asmtQnDesc;
//     _data['is_multiple_choice'] = isMultipleChoice;
//     return _data;
//   }
// }

// class Options {
//   Options({
//     required this.id,
//     required this.asmtQnOptName,
//     required this.asmtQnOptQnId,
//     required this.asmtQnOptScore,
//     required this.selected,
//   });
//   late final int id;
//   late final String asmtQnOptName;
//   late final int asmtQnOptQnId;
//   late final int asmtQnOptScore;
//   late final bool selected;

//   Options.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     asmtQnOptName = json['asmt_qn_opt_name'];
//     asmtQnOptQnId = json['asmt_qn_opt_qn_id'];
//     asmtQnOptScore = json['asmt_qn_opt_score'];
//     selected = json['selected'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['asmt_qn_opt_name'] = asmtQnOptName;
//     _data['asmt_qn_opt_qn_id'] = asmtQnOptQnId;
//     _data['asmt_qn_opt_score'] = asmtQnOptScore;
//     _data['selected'] = selected;
//     return _data;
//   }
// }

// class Assessments {
//   Assessments({
//     required this.status,
//     required this.isCombined,
//     this.asmtTypeDesc,
//     required this.data,
//   });
//   late final String status;
//   late final bool isCombined;
//   late final Null asmtTypeDesc;
//   late final List<Data> data;

//   Assessments.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     isCombined = json['is_combined'];
//     asmtTypeDesc = null;
//     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['is_combined'] = isCombined;
//     _data['asmt_type_desc'] = asmtTypeDesc;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Datas {
//   Datas({
//     required this.asmtType,
//     required this.asmtName,
//     required this.questions,
//     required this.selected,
//     required this.asmtMaxScore,
//   });
//   late final int asmtType;
//   late final String asmtName;
//   late final List<Questions> questions;
//   late final List<dynamic> selected;
//   late final int asmtMaxScore;

//   Datas.fromJson(Map<String, dynamic> json) {
//     asmtType = json['asmt_type'];
//     asmtName = json['asmt_name'];
//     questions =
//         List.from(json['questions']).map((e) => Questions.fromJson(e)).toList();
//     selected = List.castFrom<dynamic, dynamic>(json['selected']);
//     asmtMaxScore = json['asmt_max_score'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['asmt_type'] = asmtType;
//     _data['asmt_name'] = asmtName;
//     _data['questions'] = questions.map((e) => e.toJson()).toList();
//     _data['selected'] = selected;
//     _data['asmt_max_score'] = asmtMaxScore;
//     return _data;
//   }
// }

// class Questions {
//   Questions({
//     required this.question,
//     required this.options,
//   });
//   late final Question question;
//   late final List<Options> options;

//   Questions.fromJson(Map<String, dynamic> json) {
//     question = Question.fromJson(json['question']);
//     options = json['options'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['question'] = question.toJson();
//     _data['options'] = options;
//     return _data;
//   }
// }

// class Questionss {
//   Questionss({
//     required this.asmtQnId,
//     required this.asmtQnName,
//     this.asmtQnDesc,
//     required this.isMultipleChoice,
//   });
//   late final int asmtQnId;
//   late final String asmtQnName;
//   late final Null asmtQnDesc;
//   late final bool isMultipleChoice;

//   Questionss.fromJson(Map<String, dynamic> json) {
//     asmtQnId = json['asmt_qn_id'];
//     asmtQnName = json['asmt_qn_name'];
//     asmtQnDesc = null;
//     isMultipleChoice = json['is_multiple_choice'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['asmt_qn_id'] = asmtQnId;
//     _data['asmt_qn_name'] = asmtQnName;
//     _data['asmt_qn_desc'] = asmtQnDesc;
//     _data['is_multiple_choice'] = isMultipleChoice;
//     return _data;
//   }
// }

// class Option {
//   Option({
//     required this.id,
//     required this.asmtQnOptName,
//     required this.asmtQnOptQnId,
//     required this.asmtQnOptScore,
//     required this.selected,
//   });
//   late final int id;
//   late final String asmtQnOptName;
//   late final int asmtQnOptQnId;
//   late final int asmtQnOptScore;
//   late final bool selected;

//   Option.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     asmtQnOptName = json['asmt_qn_opt_name'];
//     asmtQnOptQnId = json['asmt_qn_opt_qn_id'];
//     asmtQnOptScore = json['asmt_qn_opt_score'];
//     selected = json['selected'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['asmt_qn_opt_name'] = asmtQnOptName;
//     _data['asmt_qn_opt_qn_id'] = asmtQnOptQnId;
//     _data['asmt_qn_opt_score'] = asmtQnOptScore;
//     _data['selected'] = selected;
//     return _data;
//   }
// }
