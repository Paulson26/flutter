import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/screens/messagedialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:my_thera/env.sample.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Appointmentrequest extends StatefulWidget {
  Appointmentrequest({Key? key}) : super(key: key);

  @override
  _AppointmentrequestState createState() => _AppointmentrequestState();
}

class _AppointmentrequestState extends State<Appointmentrequest> {
  final GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  final _notesController = TextEditingController();

  final String _valueChanged1 = '';
  final String _valueToValidate1 = '';
  final String _valueSaved1 = '';
  final String _valueChanged2 = '';
  final String _valueToValidate2 = '';
  final String _valueSaved2 = '';
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';

  get alertStyle => null;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _controller2 = TextEditingController(text: DateTime.now().toString());
    _controller3 = TextEditingController(text: DateTime.now().toString());

    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');

    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _controller1.text = '2000-09-20 14:30';
        _controller2.text = '2001-10-21 15:31';
        _controller3.text = '2002-11-22';
        _controller4.text = '17:01';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
          key: _oFormKey,
          child: Column(
            children: <Widget>[
              Text(
                'Request Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              DateTimePicker(
                type: DateTimePickerType.date,
                controller: _controller3,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                locale: Locale('en', ''),
                onChanged: (val) => setState(() => _valueChanged3 = val),
                validator: (val) {
                  setState(() => _valueToValidate3 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved3 = val ?? ''),
              ),
              DateTimePicker(
                type: DateTimePickerType.time,
                controller: _controller4, //_initialValue,
                icon: Icon(Icons.access_time),
                timeLabelText: "Time",
                use24HourFormat: false,
                locale: Locale('en', ''),
                onChanged: (val) => setState(() => _valueChanged4 = val),
                validator: (val) {
                  setState(() => _valueToValidate4 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved4 = val ?? ''),
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 5,
                controller: _notesController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Notes"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(right: 300.0, top: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_oFormKey.currentState!.validate()) {
                      DateTime apptdate =
                          DateFormat("yyyy-MM-dd").parse(_controller3.text);
                      String apptdate2 =
                          DateFormat('yyyy-MM-dd').format(apptdate);

                      final loForm = _oFormKey.currentState;
                      if (loForm?.validate() == true) {
                        loForm?.save();
                      }
                      const storage = FlutterSecureStorage();
                      var myJwt = await storage.read(key: "jwt");
                      var clientid = await storage.read(key: "client_id");
                      print(clientid);
                      var cliniccode = await storage.read(key: "clinic_code");
                      print(cliniccode);
                      final uri = Uri.parse(
                          'http://10.0.2.2:8000/api/v1/appointments/');
                      final response = await http.post(
                        uri,
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'JWT $myJwt',
                          'clinic_code': '$cliniccode'
                        },
                        body: {
                          "clinic_code": "${cliniccode}",
                          "appt_date": "${apptdate2}",
                          "appt_from_time": "${_controller4.text}",
                          "appt_notes": "${_notesController.text}",
                          "client_id": "${clientid}",
                        },
                        encoding: Encoding.getByName("utf-8"),
                      );
                      if (response.statusCode == 200) {
                        final responseJson = json.decode(response.body);
                        print(responseJson);
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Appointment Status",
                          desc: "Appointment request placed successfully.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "ok",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/dashboard'),
                              width: 120,
                            )
                          ],
                        ).show();
                        //Navigator.pushNamed(context, '/dashboard');
                        toast("Success Data");
                      } else {
                        throw Exception('Failed to load api');
                      }
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
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

Widget fadeAlertAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
