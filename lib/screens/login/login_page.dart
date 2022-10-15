import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_thera/env.sample.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_thera/screens/main_screen_page.dart';

final url = Env.api;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _clinicodeController = TextEditingController();

  bool _agreedToTOS = true;
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  postRequest() async {
//String _url = "IP:8000/get-token/";
    if (_oFormKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/v1/login/"),
        headers: {"Accept": "application/json"},
        body: {
          "email": "${_usernameController.text}",
          "password": "${_passwordController.text}",
          "clinic_code": "${_clinicodeController.text}",
        },
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        var today = DateTime.now();
        var dateStr = DateFormat('yyyy-MM-dd');
        var currentDate = dateStr.format(today);
        final responseJson = json.decode(response.body);
        final token = responseJson['data']['token'] as String;
        final username = responseJson['data']['user']['full_name'];
        final email = responseJson['data']['user']['email'];
        final userid = responseJson['data']['user']['id'].toString();
        final clientid = responseJson['data']['user']['client_id'].toString();
        final clinic_code = responseJson['data']['clinic']['clinic_code'];
        final clinic_id =
            responseJson['data']['clinic']['clinic_id'].toString();
        final storage = FlutterSecureStorage();
        await storage.write(key: 'jwt', value: token);
        await storage.write(key: 'clinic_id', value: clinic_id);
        await storage.write(key: 'fullname', value: username);
        await storage.write(key: 'userid', value: userid);
        await storage.write(key: 'client_id', value: clientid);
        await storage.write(key: 'clinic_code', value: clinic_code);
        await storage.write(key: 'email', value: email);
        print(responseJson);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  appt: currentDate,
                )));
      } else {
        throw Exception('Failed to load api');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _setAgreedToTOS;
    return Scaffold(
        // appBar: AppBar(

        // ),
        body: Container(
            margin: const EdgeInsets.only(bottom: 50.0),
            child: SingleChildScrollView(
                child: Form(
              key: _oFormKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        'https://static.wixstatic.com/media/05e43e_8837251be8bc44009866926024152288~mv2.png/v1/fill/w_419,h_230,al_c,enc_auto/Logo_Tagline3Transperant-compressor.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) => validateEmail(value),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _clinicodeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Clinic Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter clinic code';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _agreedToTOS,
                          onChanged: _setAgreedToTOS,
                        ),
                        GestureDetector(
                          onTap: () => _setAgreedToTOS(!_agreedToTOS),
                          child: const Text(
                            'I agree to the Terms of Services and Privacy Policy',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        postRequest();
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  )
                ],
              ),
            ))));
  }
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else {
    return null;
  }
}

// To parse this JSON data, do
//
//     final assessment = assessmentFromJson(jsonString);

