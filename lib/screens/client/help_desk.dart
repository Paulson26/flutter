// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_thera/networkHandler.dart';
import 'package:my_thera/screens/main_screen_page.dart';

// class HelpAndSupport extends StatefulWidget {
//   const HelpAndSupport({Key? key}) : super(key: key);

//   @override
//   State<HelpAndSupport> createState() => _HelpAndSupportState();
// }

// class _HelpAndSupportState extends State<HelpAndSupport>
//     with SingleTickerProviderStateMixin {
//   String _image =
//       'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
//   late AnimationController loadingController;

//   File? _file;
//   PlatformFile? _platformFile;

//   selectFile() async {
//     final file = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

//     if (file != null) {
//       setState(() {
//         _file = File(file.files.single.path!);
//         _platformFile = file.files.first;
//       });
//     }

//     loadingController.forward();
//   }

//   @override
//   void initState() {
//     loadingController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..addListener(() {
//         setState(() {});
//       });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Help & Support',
//           style: TextStyle(
//               fontSize: 25,
//               color: Colors.grey.shade800,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             // SizedBox(height: 100,),
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
//               child: TextFormField(
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: 'Tell us how we can help',
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFF0B0303),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFF0B0303),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   )),
//             ),
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
//               child: TextFormField(
//                   maxLines: 5,
//                   decoration: InputDecoration(
//                     labelText:
//                         "Explain the problem you're facing, what you've tried",
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: const Color(0xFF0B0303),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFF0B0303),
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   )),
//             ),
//             Image.network(
//               _image,
//               width: 70,
//             ),
//             // SizedBox(height: 50,),
//             // Text('Upload your file', style: TextStyle(fontSize: 25, color: Colors.grey.shade800, fontWeight: FontWeight.bold),),
//             // SizedBox(height: 10,),
//             Text(
//               'File should be jpg, png',
//               style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             GestureDetector(
//               onTap: selectFile,
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 40.0, vertical: 20.0),
//                   child: DottedBorder(
//                     borderType: BorderType.RRect,
//                     radius: const Radius.circular(10),
//                     dashPattern: [10, 4],
//                     strokeCap: StrokeCap.round,
//                     color: Colors.blue.shade400,
//                     child: Container(
//                       width: double.infinity,
//                       height: 150,
//                       decoration: BoxDecoration(
//                           color: Colors.blue.shade50.withOpacity(.3),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Iconsax.folder_open,
//                             color: Colors.blue,
//                             size: 40,
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             'Select your file',
//                             style: TextStyle(
//                                 fontSize: 15, color: Colors.grey.shade400),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//             ),
//             _platformFile != null
//                 ? Container(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Selected File',
//                           style: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     offset: const Offset(0, 1),
//                                     blurRadius: 3,
//                                     spreadRadius: 2,
//                                   )
//                                 ]),
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.file(
//                                       _file!,
//                                       width: 70,
//                                     )),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _platformFile!.name,
//                                         style: const TextStyle(
//                                             fontSize: 13, color: Colors.black),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         '${(_platformFile!.size / 1024).ceil()} KB',
//                                         style: TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.grey.shade500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Container(
//                                           height: 5,
//                                           clipBehavior: Clip.hardEdge,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             color: Colors.blue.shade50,
//                                           ),
//                                           child: LinearProgressIndicator(
//                                             value: loadingController.value,
//                                           )),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                               ],
//                             )),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         // MaterialButton(
//                         //   minWidth: double.infinity,
//                         //   height: 45,
//                         //   onPressed: () {},
//                         //   color: Colors.black,
//                         //   child: Text('Upload', style: TextStyle(color: Colors.white),),
//                         // )
//                       ],
//                     ))
//                 : Container(),
//             Container(
//               padding: const EdgeInsets.only(right: 400.0, top: 40.0),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('Submit'),
//               ),
//             ),
//             const SizedBox(
//               height: 150,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//hey

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  File? selectedImage;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Help and Support')),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            nameTextField(),
            const SizedBox(
              height: 20,
            ),
            professionTextField(),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            imageProfile(),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                const storage = FlutterSecureStorage();
                var email = await storage.read(key: "email");
                if (_globalkey.currentState!.validate()) {
                  Map<String, String> data = {
                    "user": email.toString(),
                    "subject": subject.text,
                    "description": description.text,
                  };
                  var response = await networkHandler.post(
                      "http://10.0.2.2:8000/api/v1/support/", data,
                      data: {
                        "user": email.toString(),
                        "subject": subject.text,
                        "description": description.text,
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
                          msg:
                              'We have recived your query and our support team will rectify the issue as soon as possible.',
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
                          msg:
                              'We have recived your query and our support team will rectify the issue as soon as possible.',
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
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? const CircularProgressIndicator()
                        : const Text(
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
            radius: 30.0,
            backgroundImage: selectedImage != null
                ? FileImage(File(selectedImage!.path))
                : const AssetImage("assets/images/login.png") as ImageProvider),
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
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.teal,
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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Image",
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.add_a_photo),
              onPressed: () {
                takePhoto();
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Future takePhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

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
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/v1/support/'),
    );

    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': 'JWT $myJwt',
      'clinic_code': '$cliniccode'
    };
    request.files.add(
      http.MultipartFile(
        'document',
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
    return resJson;
  }

  Widget nameTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: TextFormField(
          maxLines: 3,
          controller: subject,
          validator: (value) {
            if (value!.isEmpty) return " Title can't be empty";

            return null;
          },
          decoration: InputDecoration(
            labelText: 'Tell us how we can help',
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
    );
  }

  Widget professionTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: TextFormField(
          maxLines: 3,
          controller: description,
          validator: (value) {
            if (value!.isEmpty) return " Description can't be empty";

            return null;
          },
          decoration: InputDecoration(
            labelText: "Explain the problem you're facing, what you've tried",
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
    );
  }
}
