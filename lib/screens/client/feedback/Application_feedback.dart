import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_thera/screens/main_screen_page.dart';

class ReviewsApplication extends StatefulWidget {
  @override
  State<ReviewsApplication> createState() => ReviewsApplicationState();
}

class ReviewsApplicationState extends State<ReviewsApplication> {
  final _feedback = TextEditingController();
  String _value_for_money = "";
  String _sattisfaction = "";
  String _overall_quality = "";
  int _rating = 0;

  @override
  void initState() {
    super.initState();

    _getValue();
  }

  _getValue() {
    setState(() {
      _feedback.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Application Feedback "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // index: _stackIndex,
        child: (Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'How satisfied are you with this application?',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            RadioButton(
              description: "Excellent",
              value: "Excellent",
              groupValue: _sattisfaction,
              onChanged: (value) => setState(() {
                _sattisfaction = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Good",
              value: "Good",
              groupValue: _sattisfaction,
              onChanged: (value) => setState(() {
                _sattisfaction = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Average",
              value: "Average",
              groupValue: _sattisfaction,
              onChanged: (value) => setState(() {
                _sattisfaction = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Poor",
              value: "Poor",
              groupValue: _sattisfaction,
              onChanged: (value) => setState(() {
                _sattisfaction = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Very Poor",
              value: "Very Poor",
              groupValue: _sattisfaction,
              onChanged: (value) => setState(() {
                _sattisfaction = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'How was overall quaility of the application?',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            RadioButton(
              description: "Excellent",
              value: "Excellent",
              groupValue: _overall_quality,
              onChanged: (value) => setState(() {
                _overall_quality = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Good",
              value: "Good",
              groupValue: _overall_quality,
              onChanged: (value) => setState(() {
                _overall_quality = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Average",
              value: "Average",
              groupValue: _overall_quality,
              onChanged: (value) => setState(() {
                _overall_quality = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Poor",
              value: "Poor",
              groupValue: _overall_quality,
              onChanged: (value) => setState(() {
                _overall_quality = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Very Poor",
              value: "Very Poor",
              groupValue: _overall_quality,
              onChanged: (value) => setState(() {
                _overall_quality = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'How would you rate our application on value for money?',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            RadioButton(
              description: "Excellent",
              value: "Excellent",
              groupValue: _value_for_money,
              onChanged: (value) => setState(() {
                _value_for_money = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Good",
              value: "Good",
              groupValue: _value_for_money,
              onChanged: (value) => setState(() {
                _value_for_money = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Average",
              value: "Average",
              groupValue: _value_for_money,
              onChanged: (value) => setState(() {
                _value_for_money = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Poor",
              value: "Poor",
              groupValue: _value_for_money,
              onChanged: (value) => setState(() {
                _value_for_money = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            RadioButton(
              description: "Very Poor",
              value: 'Very Poor',
              groupValue: _value_for_money,
              onChanged: (value) => setState(() {
                _value_for_money = value.toString();
              }),
              activeColor: Colors.pink,
              textStyle: const TextStyle(
                  // fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: TextFormField(
                  controller: _feedback,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'What can we do to improve our service?',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF0B0303),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF0B0303),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating.toInt();
                print(_rating);
              },
            ),
            Container(
              height: 50.0,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  print(this._value_for_money);
                  print(this._overall_quality);
                  print(this._rating);
                  print(this._sattisfaction);
                  const storage = FlutterSecureStorage();
                  var myJwt = await storage.read(key: "jwt");
                  var userId = await storage.read(key: "userid");
                  var cliniccode = await storage.read(key: "clinic_code");
                  var clinicId = await storage.read(key: "clinic_id");
                  var map = Map<String, String>();
                  map['feedback'] = _feedback.text;

                  map["value_for_money"] = this._value_for_money;
                  map["overall_quality"] = this._overall_quality;
                  map["rating"] = "${this._rating}";
                  map["sattisfaction"] = this._sattisfaction;
                  map["rated_by"] = "$userId";
                  map["clinic"] = "$clinicId";

                  final uri = Uri.parse(
                      'http://10.0.2.2:8000/api/v1/applicationfeedback/');
                  //final response = await http.post(
                  //   uri,
                  //   headers: {
                  //     'Authorization': 'JWT $myJwt',
                  //     'clinic_code': '$cliniccode',
                  //   },
                  //   body: map,
                  // );
                  Map<String, String> headers = {
                    'Authorization': 'JWT $myJwt',
                    'clinic_code': '$cliniccode',
                  };
                  var request = http.MultipartRequest('POST', uri)
                    ..fields.addAll(map);
                  request.headers.addAll(headers);
                  var response = await request.send();
                  if (response.statusCode == 200) {
                    final respStr = await response.stream.bytesToString();
                    final responseJson = json.decode(respStr);
                    print(responseJson);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        (route) => false);
                    Fluttertoast.showToast(
                        msg:
                            "Thank you for reaching out and providing us with valuable feedback.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    throw Exception('Failed to load api');
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(0, 255, 255, 255),
                          Color.fromARGB(0, 111, 121, 142)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Submit Feedback",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        )),
      ),
    );
  }
}
