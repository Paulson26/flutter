// import 'dart:convert';
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyHomePage5 extends StatefulWidget {
  MyHomePage5({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePage5State createState() => _MyHomePage5State();
}

class _MyHomePage5State extends State<MyHomePage5> {
  File? selectedImage;
  var resJson;

  onUploadImage() async {
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
    setState(() {
      resJson = jsonDecode(response.body);
    });
  }

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedImage == null
                ? Text(
                    'Please Pick a image to Upload',
                  )
                : Image.file(selectedImage!),
            ElevatedButton(
              onPressed: onUploadImage,
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
