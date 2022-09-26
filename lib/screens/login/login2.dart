import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_thera/model/userlogin.dart';
import 'package:my_thera/model/user.dart';
import 'package:my_thera/env.sample.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final url = Env.api;

class LoginPage extends StatefulWidget {
   LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _clinicodeController = TextEditingController();

bool _agreedToTOS = true;

showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
            children: [
               CircularProgressIndicator(),
               Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
    postRequest() async {
//String _url = "IP:8000/get-token/";
var response = await http.post(
  Uri.parse(url+'login'),
  headers: { "Accept" : "application/json"},
  body: {
    "email": "${_usernameController.text}",
    "password": "${_passwordController.text}",
    "clinic_code": "${_clinicodeController.text}",
  },
  encoding: Encoding.getByName("utf-8"),
);
  //     Future<Post> _getData({String name1, String name2}) async {
  //   final response = await http.get(
  //       'https://love-calculator.p.rapidapi.com/getPercentage?fname=$name1&sname=$name2',
  //       headers: {
  //         'x-rapidapi-host': 'love-calculator.p.rapidapi.com',
  //         'x-rapidapi-key':
  //             '84e84770b9msh59a96d8b03cb4aap1615a1jsn1cd0efaeedfe',
  //       });

  //   if (response.statusCode == 200) {
  //     final responseJson = json.decode(response.body);
  //     setState(() {
  //       percentage = int.parse(responseJson['percentage']);
  //       result = responseJson['result'];
  //     });
  //   } else {
  //     throw Exception('Failed to load api');
  //   }
  // }
  Future<Token> getToken(UserLogin userLogin) async {
  print(url);
  final http.Response response = await http.post(
    Uri.parse(url+'login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}

   Future<http.Response> buttonPressed() async {
    http.Response returnedResult = await http.get(
        Uri.parse('http://localhost:8000/app/hellodjango'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset-UTF-8'
        });
    print(returnedResult.body);
    return returnedResult;
  }

  @override
  Widget build(BuildContext context) {
    var _setAgreedToTOS;
    return Scaffold(
      // appBar: AppBar(
        
      // ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.network('https://static.wixstatic.com/media/05e43e_8837251be8bc44009866926024152288~mv2.png/v1/fill/w_419,h_230,al_c,enc_auto/Logo_Tagline3Transperant-compressor.png'),
            
          ),
          Container(
            padding:  const EdgeInsets.all(10),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding:  const EdgeInsets.all(10),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding:  const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Clinic Code',
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Checkbox(value: _agreedToTOS,
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
              height:60,
              onPressed: ()async {
                postRequest();

              },
              color: Colors.blue,
               shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(40)
                ),
                child: Text("Sign In",style: TextStyle(
                  fontWeight: FontWeight.w600,fontSize: 16, color: Colors.white,
                ),),
              ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? "),
              Text("Login",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
            ],
          )
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}