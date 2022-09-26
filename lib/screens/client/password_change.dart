import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_thera/screens/main_screen_page.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isObscure = true;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool pass = true;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController retypedPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getValue();
  }

  _getValue() {
    setState(() {
      oldPassword.text = '';
      newPassword.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
        ),
      ),
      body: Form(
        key: _globalkey,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: oldPassword,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      suffixIcon: oldPassword.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _isObscure = !_isObscure),
                            ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: _isObscure,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: pass ? _isObscure1 : false,
                    controller: newPassword,
                    decoration: InputDecoration(
                      suffixIcon: pass
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure1 = !_isObscure1;
                                });
                              },
                              icon: _isObscure1
                                  ? const Icon(
                                      Icons.visibility_off,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                    ),
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: (value) {
                      if (newPassword.text != retypedPassword.text) {
                        return "password does not match";
                      }

                      return null;
                    },
                    obscureText: pass ? _isObscure2 : false,
                    controller: retypedPassword,
                    decoration: InputDecoration(
                      suffixIcon: pass
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              },
                              icon: _isObscure2
                                  ? const Icon(
                                      Icons.visibility_off,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                    ),
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      labelText: 'Re-type Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () async {
                        const storage = FlutterSecureStorage();
                        var myJwt = await storage.read(key: "jwt");
                        var userId = await storage.read(key: "userid");
                        var cliniccode = await storage.read(key: "clinic_code");
                        var clinicId = await storage.read(key: "clinic_id");
                        if (_globalkey.currentState!.validate()) {
                          var map = <String, String>{};
                          map["old_password"] = oldPassword.text;
                          map["user_id"] = "$userId";
                          map["new_password"] = newPassword.text;

                          final uri = Uri.parse(
                              'http://10.0.2.2:8000/api/v1/changePassword/');
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
                          var request = http.MultipartRequest('PUT', uri)
                            ..fields.addAll(map);
                          request.headers.addAll(headers);
                          var response = await request.send();
                          if (response.statusCode == 200) {
                            final respStr =
                                await response.stream.bytesToString();
                            final responseJson = json.decode(respStr);
                            print(responseJson);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                                (route) => false);
                            Fluttertoast.showToast(
                                msg: "Password Changed Successfully.",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            throw Exception('Failed to load api');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 70, 39, 209),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
