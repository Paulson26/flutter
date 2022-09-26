import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:my_thera/screens/client/payment/pay.dart';
//import 'dart:io';
import 'package:my_thera/screens/messagedialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Submitforinsurenceapproval extends StatefulWidget {
  Submitforinsurenceapproval(
      {Key? key,
      required this.client_id,
      required this.apptid,
      required this.insurence_reject_comment})
      : super(key: key);

  final client_id;
  final apptid;
  final insurence_reject_comment;

  @override
  State<Submitforinsurenceapproval> createState() =>
      _SubmitforinsurenceapprovalState();
}

class _SubmitforinsurenceapprovalState
    extends State<Submitforinsurenceapproval> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();

  // File? _file;

  PlatformFile? _platformFile;
  //File? selectedImage;
  String uploadfile = '';
  TextEditingController insurenceproviderController = TextEditingController();
  TextEditingController insurencidController = TextEditingController();
  var insurenceid_photo = '';

  final form = GlobalKey<FormState>();

  //selectFile() async {
  //   final file = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

  //   if (file != null) {
  //     setState(() {
  //       Uint8List? uploadfilee = file.files.single.bytes;
  //       selectedImage = uploadfilee as File?;
  //       //_file = File(file.files.single.bytes);

  //       print(selectedImage);
  //     });
  //   }

  //   // loadingController.forward();
  // }

  PlatformFile? insurancephoto;
  void selectFile1() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg'],
      withReadStream: true,
      // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        insurancephoto = result.files.single;
      });
    }
  }

  Future fetchResults() async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    final uri = Uri.parse('http://10.0.2.2:8000/api/v1/client/')
        .replace(queryParameters: {
      'id': clientid,
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
    print("in insurence confirm page");
    print(resultsJson);
    setState(() {
      insurenceproviderController.text =
          resultsJson['data']['client_insurance_provider'];
      insurencidController.text = resultsJson['data']['client_insurence_id'];
      insurenceid_photo = resultsJson['data']['insurence_id_photo'];
    });
  }

  void initState() {
    super.initState();
    fetchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Submit for Insurance'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: 30,
              ),
              Center(
                child: Text(
                  'Please Do Submit Additional Details for Insurance Claim',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.admin_panel_settings_sharp),
                title: TextFormField(
                  controller: insurenceproviderController,
                  decoration: InputDecoration(
                    hintText: "Insurance Provider*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_moderator_outlined),
                title: TextFormField(
                  controller: insurencidController,
                  decoration: InputDecoration(
                    hintText: "Insurance ID*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box_outlined),
                title: Text("Photo of Insurance Id card*"),
              ),
              if (insurenceid_photo != null)
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff94d500),
                  child: IconButton(
                    icon: const Icon(Icons.image),
                    tooltip: 'view already submitted id photo',
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => viewinsurencephoto(
                                photourl:
                                    'http://10.0.2.2:8000$insurenceid_photo',
                              )))
                    },
                  ),
                ),

              SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Attach Photo of Insurance Id card Below',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 20, 12, 12),
                  ),
                ),
              ),
              if (insurancephoto == null)
                ElevatedButton(
                    child: const Text(
                        "Choose Photo of Insurance Id card to Upload"),
                    onPressed: () => selectFile1()),
              if (insurancephoto != null)
                ElevatedButton(
                    child: Text(" Document Selected(${insurancephoto!.name})"),
                    onPressed: () => selectFile1()),
              if (insurancephoto != null)
                Text("Document size : ${insurancephoto!.size} bytes"),
              // GestureDetector(
              //   onTap: selectFile1,
              //   child: Padding(
              //       padding:
              //           EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              //       child: DottedBorder(
              //         borderType: BorderType.RRect,
              //         radius: Radius.circular(10),
              //         dashPattern: [10, 4],
              //         strokeCap: StrokeCap.round,
              //         color: Colors.blue.shade400,
              //         child: Container(
              //           width: double.infinity,
              //           height: 150,
              //           decoration: BoxDecoration(
              //               color: Colors.blue.shade50.withOpacity(.3),
              //               borderRadius: BorderRadius.circular(10)),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Icon(
              //                 Iconsax.folder_open,
              //                 color: Colors.blue,
              //                 size: 40,
              //               ),
              //               SizedBox(
              //                 height: 15,
              //               ),
              //             ],
              //           ),
              //         ),
              //       )),
              // ),
              ListTile(
                leading: Icon(Icons.assignment_return_outlined),
                title: Text(widget.insurence_reject_comment),
              ),
              Container(
                padding: const EdgeInsets.only(right: 300.0, top: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    var myJwt = await storage.read(key: "jwt");
                    var clientid = await storage.read(key: "client_id");
                    print(clientid);
                    var cliniccode = await storage.read(key: "clinic_code");
                    var map = new Map<String, String>();
                    map['client_insurance_provider'] =
                        "${insurenceproviderController.text}";
                    map['client_insurence_id'] = "${insurencidController.text}";
                    map['id'] = "${clientid}";
                    map["payment_mode"] = "Insurance";
                    // if (objFile != null) {
                    //   map["insurence_id_photo"] = "${objFile}";
                    // }

                    final uri =
                        Uri.parse('http://10.0.2.2:8000/api/v1/client/');
                    // final response = await http.put(
                    //   uri,
                    //   headers: {
                    //     'Accept': 'application/json',
                    //     'Authorization': 'JWT $myJwt',
                    //     'clinic_code': '$cliniccode'
                    //   },
                    //   body: {
                    //     "client_insurance_provider":"${insurenceproviderController.text}",
                    //     "client_insurence_id": "${insurencidController.text}",
                    //     "payment_mode": "Insurance",
                    //     "id":"${clientid}",
                    //   },
                    //   encoding: Encoding.getByName("utf-8"),
                    // );
                    Map<String, String> headers = {
                      'Authorization': 'JWT $myJwt',
                      'clinic_code': '$cliniccode',
                    };
                    var request = http.MultipartRequest('PUT', uri)
                      ..fields.addAll(map);
                    request.files.add(http.MultipartFile("insurence_id_photo",
                        insurancephoto!.readStream!, insurancephoto!.size,
                        filename: insurancephoto!.name));
                    request.headers.addAll(headers);
                    var response = await request.send();
                    if (response.statusCode == 200) {
                      //final respStr = await response.stream.bytesToString();
                      // final responseJson = json.decode(respStr);
                      //print(responseJson);
                      final uri = Uri.parse(
                          'http://10.0.2.2:8000/api/v1/appointments/');
                      final response = await http.put(
                        uri,
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'JWT $myJwt',
                          'clinic_code': '$cliniccode'
                        },
                        body: {
                          "id": "${widget.apptid}",
                          "appt_status": "WAITING FOR INSURANCE CNFRM",
                          "is_insurance": 'true',
                        },
                        encoding: Encoding.getByName("utf-8"),
                      );
                      if (response.statusCode == 200) {
                        final responseJson = json.decode(response.body);

                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Appointment Status",
                          desc:
                              "request for insurence payment placed successfully.",
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
                    } else {
                      throw Exception('Failed to load api');
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
