// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_thera/networkHandler.dart';
import 'package:my_thera/screens/main_screen_page.dart';

class CreatProfile extends StatefulWidget {
  const CreatProfile(
      {Key? key,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.profileimage})
      : super(key: key);
  final firstname;
  final middlename;
  final lastname;
  final profileimage;
  @override
  _CreatProfileState createState() => _CreatProfileState();
}

class _CreatProfileState extends State<CreatProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  File? selectedImage;
  final _globalkey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _middlename = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  initState() {
    _firstname.text = widget.firstname;
    _middlename.text = widget.middlename;
    _lastname.text = widget.lastname;
    //_loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Update Profile')),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            professionTextField(),
            SizedBox(
              height: 20,
            ),
            dobField(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                const storage = FlutterSecureStorage();
                var id = await storage.read(key: "userid");
                if (_globalkey.currentState!.validate()) {
                  Map<String, String> data = {
                    "id": id.toString(),
                    "first_name": _firstname.text,
                    "middle_name": _middlename.text,
                    "last_name": _lastname.text,
                  };
                  var response = await networkHandler
                      .put("http://10.0.2.2:8000/api/v1/user/", data, data: {
                    "id": id.toString(),
                    "first_name": _firstname.text,
                    "middle_name": _middlename.text,
                    "last_name": _lastname.text,
                  });
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    if (selectedImage != null) {
                      var imageResponse =
                          uploadImage("Uploaded", selectedImage!);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MainScreen(
                                    appt: null,
                                  )),
                          (route) => false);
                      Fluttertoast.showToast(
                          msg: "Profile updated successfully!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MainScreen(
                                    appt: null,
                                  )),
                          (route) => false);
                      Fluttertoast.showToast(
                          msg: "Profile updated successfully!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 92, 179, 250),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
            radius: 80.0,
            backgroundImage: selectedImage != null
                ? FileImage(File(selectedImage!.path))
                : NetworkHandler().getImage(widget.profileimage)
                    as ImageProvider),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 93, 175, 246),
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            )
          ])
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  uploadImage(String title, File file) async {
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var id = await storage.read(key: "userid");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://10.0.2.2:8000/api/v1/user/$id'),
    );
    request.fields["id"] = id.toString();
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': 'JWT $myJwt',
      'clinic_code': '$cliniccode'
    };
    request.files.add(
      http.MultipartFile(
        'avatar',
        selectedImage!.readAsBytes().asStream(),
        selectedImage!.lengthSync(),
        filename: selectedImage!.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);

    var resJson = jsonDecode(response.body);
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _firstname,
      validator: (value) {
        if (value!.isEmpty) return "First Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 93, 175, 246),
        ),
        labelText: "First Name",
        helperText: "First Name can't be empty",
        hintText: "First Name",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) return "Middle Name can't be empty";

        return null;
      },
      controller: _middlename,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 93, 175, 246),
        ),
        labelText: "Middle Name",
        helperText: "optional",
        hintText: "Middle Name",
      ),
    );
  }

  Widget dobField() {
    return TextFormField(
      controller: _lastname,
      validator: (value) {
        if (value!.isEmpty) return "Last Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 93, 175, 246),
        ),
        labelText: "Last Name",
        helperText: "Last Name can't be empty",
        hintText: "Last Name",
      ),
    );
  }
}
