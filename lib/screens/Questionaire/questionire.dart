// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_thera/env.sample.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../messagedialog.dart';

class QuestionairePage extends StatefulWidget {
  const QuestionairePage(
      {Key? key, required this.appt_id, required this.firstvisit})
      : super(key: key);
  final appt_id;
  final firstvisit;

  @override
  State<QuestionairePage> createState() => _QuestionairePageState();
}

class ItemCls {
  final bool values;

  ItemCls({
    required this.values,
  });
}

class _QuestionairePageState extends State<QuestionairePage> {
  final List<String> items = [
    'sincebirth',
    'sudden',
    'gradual',
  ];
  ItemCls? currentValue;
  ItemCls? currentValue1;
  ItemCls? currentValue2;
  ItemCls? currentValue3;
  static List<ItemCls> itemList = [
    ItemCls(values: true),
    ItemCls(values: false)
  ];

  final List<DropdownMenuItem<ItemCls>> _menuItem = <DropdownMenuItem<ItemCls>>[
    DropdownMenuItem<ItemCls>(
        value: itemList[0],
        child: const SizedBox(
          width: 200.0,
          child: Text("Yes"),
        )),
    DropdownMenuItem<ItemCls>(
        value: itemList[1],
        child: const SizedBox(
          width: 200.0,
          child: Text("No"),
        ))
  ];

  final _duration_of_sicknessController = TextEditingController();
  final age_noticedController = TextEditingController();
  final first_sought_ageController = TextEditingController();
  final med_treatedController = TextEditingController();
  final current_medicationController = TextEditingController();
  final current_medication_detailsController = TextEditingController();
  final earlier_treatmentController = TextEditingController();
  final unusual_behaviorController = TextEditingController();

  final unusual_behavior_detailsController = TextEditingController();
  final family_historyController = TextEditingController();

  final family_history_detailsController = TextEditingController();

  final suicidalthoughtsexplanationController = TextEditingController();
  String? selectedValuedurationofsickness;
  bool currentmedication = false;
  bool unusualbehaviour = false;
  bool familyhistory = false;
  bool mentalhealth = false;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          //If it's last item, we will not add Divider after it.

          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }

    return _menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];

    for (var i = 0; i < (items.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes

      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }

    return _dividersIndexes;
  }

  File? _file;

  PlatformFile? objFile;

  void selectFile() async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
    }
  }

  int _valuedepression = 0;
  int _valueanxity = 0;
  int _valueobsessive = 0;
  int _valuepoorsleep = 0;
  int _valueunfocusedthoughts = 0;
  int _valuepoorimpulsecontrol = 0;
  int _valueprogressafterfiestvisit = 0;
  int _valueselfharm = 0;
  bool _selfharmorsuicidalValue = false;
  int overAllProgress = 0;
  String uploadfile = '';
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    _getValue();
  }

  _getValue() {
    setState(() {
      _duration_of_sicknessController.text = '';
      age_noticedController.text = '';
      first_sought_ageController.text = '';
      med_treatedController.text = '';
      current_medicationController.text = '';
      current_medication_detailsController.text = '';
      earlier_treatmentController.text = '';
      unusual_behaviorController.text = '';
      unusual_behavior_detailsController.text = '';
      family_historyController.text = '';
      family_history_detailsController.text = '';
      suicidalthoughtsexplanationController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: FlutterFlowTheme.of(context).primaryColor,

          title: const Text(
            'Check-in Questionnaire',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              if (widget.firstvisit)
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            'Duration of the sickness*',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: _addDividersAfterItems(items),
                          customItemsIndexes: _getDividersIndexes(),
                          customItemsHeight: 4,
                          value: selectedValuedurationofsickness,
                          onChanged: (value) {
                            setState(() {
                              selectedValuedurationofsickness = value as String;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 450,
                          itemHeight: 40,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: TextFormField(
                        autofocus: true,
                        obscureText: false,
                        controller: age_noticedController,
                        keyboardType: TextInputType.number,

                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Age When Noticed*',
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
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: TextFormField(
                        autofocus: true,
                        obscureText: false,
                        controller: first_sought_ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              'Age when medical attention was first sought*',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF0B0303),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: const Color(0xFF0B0303),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Text("Any current medical or mental health*"),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ItemCls>(
                            hint: const Text("select here"),
                            value: currentValue,
                            items: _menuItem,
                            onChanged: (value) {
                              setState(() {
                                currentValue = value;
                                mentalhealth = currentValue!.values;
                              });
                              // print(value);
                            }),
                      ),
                    ),
                    Text("Any current medications?*"),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ItemCls>(
                            hint: const Text("select here"),
                            value: currentValue1,
                            items: _menuItem,
                            onChanged: (value) {
                              setState(() {
                                currentValue1 = value;
                                currentmedication = currentValue1!.values;
                              });
                              // print(value);
                            }),
                      ),
                    ),
                    if (currentmedication == true)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 20, 20, 20),
                        child: TextFormField(
                            maxLines: 3,
                            controller: current_medication_detailsController,
                            decoration: InputDecoration(
                              labelText: 'Details',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
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
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: TextFormField(
                          maxLines: 3,
                          controller: earlier_treatmentController,
                          decoration: InputDecoration(
                            labelText: 'Details of earlier treatment*',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF0B0303),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: const Color(0xFF0B0303),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    ),
                    Text("Unusual behaviours observed?*"),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ItemCls>(
                            hint: const Text("select here"),
                            value: currentValue2,
                            items: _menuItem,
                            onChanged: (value) {
                              setState(() {
                                currentValue2 = value;
                                unusualbehaviour = currentValue2!.values;
                                print(currentValue2!.values);
                              });
                              // print(value);
                            }),
                      ),
                    ),
                    if (unusualbehaviour == true)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 10, 20, 20),
                        child: TextFormField(
                            maxLines: 3,
                            controller: unusual_behavior_detailsController,
                            decoration: InputDecoration(
                              labelText: 'Details',
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
                    Text("Family history for mental illness?*"),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ItemCls>(
                            hint: const Text("select here"),
                            value: currentValue3,
                            items: _menuItem,
                            onChanged: (value) {
                              setState(() {
                                currentValue3 = value;
                                familyhistory = currentValue3!.values;
                                print(currentValue3!.values);
                              });
                              // print(value);
                            }),
                      ),
                    ),
                    if (familyhistory == true)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 20, 20, 20),
                        child: TextFormField(
                            maxLines: 3,
                            controller: family_history_detailsController,
                            decoration: InputDecoration(
                              labelText: 'Details',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF0B0303),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: const Color(0xFF0B0303),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Attach Documents Below(previous medication history, other documents)',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 20, 12, 12),
                        ),
                      ),
                    ),
                    if (objFile == null)
                      ElevatedButton(
                          child: const Text("Choose Document to Upload"),
                          onPressed: () => selectFile()),
                    if (objFile != null)
                      ElevatedButton(
                          child: Text(" Document Selected(${objFile!.name})"),
                          onPressed: () => selectFile()),
                    if (objFile != null)
                      Text("Document size : ${objFile!.size} bytes"),
                  ],
                ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: const Text("Depression"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valuedepression,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valuedepression = newValue.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Anxiety"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valueanxity,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valueanxity = newValue.toInt();
                            ;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Obsessive Thoughts"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valueobsessive,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valueobsessive = newValue.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Poor Sleep"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valuepoorsleep,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valuepoorsleep = newValue.toInt();
                            ;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Unfocused Thoughts"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valueunfocusedthoughts,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valueunfocusedthoughts = newValue.toInt();
                            ;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Poor Impulse Control"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valuepoorimpulsecontrol,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valuepoorimpulsecontrol = newValue.toInt();
                            ;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text("Any progress after First Visit"),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SfSlider(
                        min: 0.0,
                        max: 10.0,
                        value: _valueprogressafterfiestvisit,
                        interval: 1,
                        showLabels: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _valueprogressafterfiestvisit = newValue.toInt();
                            ;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text(
                      "Are you having any self harm or suicidal thoughts ?"),
                  CupertinoSwitch(
                    value: _selfharmorsuicidalValue,
                    onChanged: (value) {
                      setState(() {
                        _selfharmorsuicidalValue = value;
                      });
                    },
                  ),
                ],
              ),
              if (_selfharmorsuicidalValue)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text("Self Harm or Suicidal Thoughts"),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: SfSlider(
                          min: 0.0,
                          max: 10.0,
                          value: _valueselfharm,
                          interval: 1,
                          showLabels: true,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              _valueselfharm = newValue.toInt();
                              ;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                height: 50.0,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    print(this._valueanxity);
                    print(this._valuedepression);
                    print("value down");
                    print(widget.appt_id);
                    print(widget.firstvisit);
                    const storage = FlutterSecureStorage();
                    var myJwt = await storage.read(key: "jwt");
                    var clientid = await storage.read(key: "client_id");
                    var cliniccode = await storage.read(key: "clinic_code");
                    var map = Map<String, String>();
                    map['is_first_visit'] = "${widget.firstvisit}";
                    map['duration_of_sickness'] =
                        "$selectedValuedurationofsickness";
                    map['age_noticed'] = age_noticedController.text;
                    map['first_sought_age'] = first_sought_ageController.text;
                    map['med_treated'] = "$mentalhealth";
                    map["current_medication"] = "$currentmedication";
                    map["current_medication_details"] =
                        current_medication_detailsController.text;
                    map["earlier_treatment"] = earlier_treatmentController.text;
                    map["unusual_behavior"] = "$unusualbehaviour";
                    map["unusual_behavior_details"] =
                        unusual_behavior_detailsController.text;
                    map["family_history"] = "$familyhistory";
                    map["family_history_details"] =
                        family_history_detailsController.text;
                    map["depression"] = "${this._valuedepression}";
                    map["anxiety"] = "${this._valueanxity}";
                    map["obsessive_thoughts"] = "${this._valueobsessive}";
                    map["poor_sleep"] = "${this._valuepoorsleep}";
                    map["unfocused_thoughts"] =
                        "${this._valueunfocusedthoughts}";
                    map["poor_impulse_control"] =
                        "${this._valuepoorimpulsecontrol}";
                    map["progress_after_first_visit"] =
                        "${this._valueprogressafterfiestvisit}";
                    map["self_harm_points"] = "${this._valueselfharm}";
                    map["suicidalthoughtsexplanation"] =
                        suicidalthoughtsexplanationController.text;
                    map["self_harm_suicidal_thoughts"] =
                        "${this._selfharmorsuicidalValue}";
                    map["appt_id"] = "${widget.appt_id}";
                    map["overall_progress"] = "${this.overAllProgress}";
                    print(map);

                    final uri = Uri.parse(
                        'http://10.0.2.2:8000/api/v1/checkin-question/');
                    // final response = await http.post(
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
                    request.files.add(http.MultipartFile(
                        "document", objFile!.readStream!, objFile!.size,
                        filename: objFile!.name));
                    var response = await request.send();
                    if (response.statusCode == 200) {
                      final respStr = await response.stream.bytesToString();
                      final responseJson = json.decode(respStr);
                      print(responseJson);
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Appointment Status",
                        desc: responseJson['message'],
                        buttons: [
                          DialogButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/dashboard'),
                            width: 120,
                            child: const Text(
                              "ok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ).show();

                      toast(responseJson['message']);
                    } else {
                      throw Exception('Failed to load api');
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints: const BoxConstraints(
                          maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit Questionaire",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}

select() {}
