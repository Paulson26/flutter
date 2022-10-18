// ignore_for_file: unused_field, use_build_context_synchronously, depend_on_referenced_packages, override_on_non_overriding_member

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_thera/screens/messagedialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:time_machine/time_machine.dart';
import 'package:intl/intl.dart';

class JsonData extends StatelessWidget {
  const JsonData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnlineJsonData(),
    );
  }
}

class OnlineJsonData extends StatefulWidget {
  const OnlineJsonData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarExample();
}

class CalendarExample extends State<OnlineJsonData> {
  String _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String datas = "";
  List data = [];
  DateTime? firstdate;
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
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController notes = TextEditingController();
  final CalendarController _controller = CalendarController();
  DateTime? _datePicked = DateTime.now();
  final List<Color> _colorCollection = <Color>[];
  String? _networkStatusMsg;
  final Connectivity _internetConnectivity = Connectivity();
  String currentDate = '';
  List assessmentData = [];
  int minutes = 0;
  var valueText;
  @override
  void initState() {
    _initializeEventColor();
    getDataFromWeb();
    super.initState();
    var today = DateTime.now();
    var dateStr = DateFormat('yyyy-MM-dd');
    currentDate = dateStr.format(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: _datePicked!,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100))
                  .then((DateTime? date) {
                if (date != null) _controller.displayDate = date;
              });
            },
            child: const Icon(
              Icons.date_range,
              color: Colors.white,
            ),
          )
        ],
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Calendar'),
      ),
      body: FutureBuilder(
        future: getDataFromWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return SfCalendar(
              view: CalendarView.week,
              monthViewSettings: const MonthViewSettings(showAgenda: true),
              allowDragAndDrop: true,
              onDragStart: dragStart,
              onTap: calendarTapped,
              controller: _controller,
              onViewChanged: _viewChanged,
              allowAppointmentResize: true,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
              dataSource: MeetingDataSource(snapshot.data),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      _datePicked = viewChangedDetails
          .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
    });
  }

  void dragStart(AppointmentDragStartDetails appointmentDragStartDetails) {
    final Meeting appointment =
        appointmentDragStartDetails.appointment! as Meeting;
    final CalendarResource? resource = appointmentDragStartDetails.resource;
    firstdate = appointment.from;
  }

  void dragUpdate(AppointmentDragUpdateDetails appointmentDragUpdateDetails) {
    final dynamic appointment = appointmentDragUpdateDetails.appointment;
    final DateTime? draggingTime = appointmentDragUpdateDetails.draggingTime;
    final CalendarResource? resource =
        appointmentDragUpdateDetails.sourceResource;
    final CalendarResource? targetResource =
        appointmentDragUpdateDetails.targetResource;
  }

  Future<List<Meeting>> getDataFromWeb() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");

    var cliniccode = await storage.read(key: "clinic_code");

    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/searchAppointment')
        .replace(queryParameters: {
      'clinic_code': cliniccode,
      'client_id': clientid,
      //'appt_date': currentDate
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
    assessmentData = json.decode(response.body);
    final List<Meeting> appointmentData = [];
    final Random random = Random();

    int id = 0;

    for (var i = 0; i < assessmentData.length; i++) {
      if (assessmentData[i]['appt_duration'].toInt() == 0) {
        minutes = 30;
      } else {
        minutes = assessmentData[i]['appt_duration'].toInt();
      }

      var date = _convertDateFromString(assessmentData[i]['appt_date'] +
          " " +
          assessmentData[i]['appt_from_time']);
      var date1 = DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second);
      var date2 = date1.add(Duration(minutes: minutes));
      id = assessmentData[i]['id'];
      Meeting meetingData = Meeting(
          eventName: assessmentData[i]['appt_purpose'] ?? "Appointment",
          from: DateFormat('yyyy-MM-dd HH:mm:ss').parse(date.toString()),
          to: DateFormat('yyyy-MM-dd HH:mm:ss').parse(date2.toString()),
          background: _colorCollection[random.nextInt(9)],
          allDay: false,
          id: id,
          recurrenceId: minutes);
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  DateTime? _convertStringToDateTime(String time) {
    DateTime? _dateTime;
    try {
      _dateTime = DateFormat("HH:mm").parse(time);
    } catch (e) {}
    return _dateTime;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName.toString();
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from!)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from!).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to!).toString();
      _timeDetails = '$_startTimeText - $_endTimeText';
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(_subjectText),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          _dateText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(_timeDetails,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'))
              ],
            );
          });
    } else if (details.targetElement == CalendarElement.calendarCell) {
      _dateText = DateFormat("yyyy-MM-dd").format(details.date!);
      _timeDetails = DateFormat('HH:mm').format(details.date!);
      dateinput.text = _dateText;
      timeinput.text = _timeDetails;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                content: Column(
                  children: <Widget>[
                    const Text(
                      'Request Appointment',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: dateinput,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: const Icon(Icons.event),
                      locale: const Locale('en', ''),
                      onChanged: (val) => setState(() => _valueChanged3 = val),
                      validator: (val) {
                        setState(() => _valueToValidate3 = val ?? '');
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _valueSaved3 = val ?? ''),
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.time,
                      controller: timeinput, //_initialValue,
                      icon: const Icon(Icons.access_time),
                      timeLabelText: "Time",
                      use24HourFormat: false,
                      locale: const Locale('en', ''),
                      onChanged: (val) => setState(() => _valueChanged4 = val),
                      validator: (val) {
                        setState(() => _valueToValidate4 = val ?? '');
                        return null;
                      },
                      onSaved: (val) =>
                          setState(() => _valueSaved4 = val ?? ''),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: 5,
                      controller: notes,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Notes"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              DateTime apptdate = DateFormat("yyyy-MM-dd")
                                  .parse(dateinput.text);
                              String apptdate2 =
                                  DateFormat('yyyy-MM-dd').format(apptdate);
                              print(apptdate2);
                              const storage = FlutterSecureStorage();
                              var myJwt = await storage.read(key: "jwt");
                              var clientid =
                                  await storage.read(key: "client_id");
                              var cliniccode =
                                  await storage.read(key: "clinic_code");
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
                                  "clinic_code": "$cliniccode",
                                  "appt_date": apptdate2,
                                  "appt_from_time": timeinput.text,
                                  "appt_notes": notes.text,
                                  "client_id": "$clientid",
                                },
                                encoding: Encoding.getByName("utf-8"),
                              );
                              if (response.statusCode == 200) {
                                final responseJson = json.decode(response.body);
                                print(responseJson);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const JsonData()),
                                    (route) => false);
                                //Navigator.pushNamed(context, '/dashboard');
                                toast("Appointment Requested");
                              } else {
                                toast1(
                                    "You already have Appointment on same day!");
                              }
                            },
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 185, 11, 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

class MeetingDataSource extends CalendarDataSource<Meeting> {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  Object? getRecurrenceId(int index) {
    return appointments![index].recurrenceId as Object?;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }

  @override
  Object? getId(int index) {
    return appointments![index].id;
  }
}

class Meeting {
  Meeting(
      {this.eventName,
      this.event,
      this.from,
      this.to,
      this.background,
      this.id,
      this.recurrenceId,
      this.duration,
      this.allDay = false});

  String? eventName;
  String? event;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? allDay;
  int? id;
  int? recurrenceId;
  int? duration;
}
