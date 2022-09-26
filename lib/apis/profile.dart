import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ImageService {
  static Future<dynamic> uploadFile(filePath) async {
    //jwt authentication token
    const storage = FlutterSecureStorage();
    var myJwt = await storage.read(key: "jwt");
    var clientid = await storage.read(key: "client_id");
    var id = await storage.read(key: "id");
    print(clientid);
    var cliniccode = await storage.read(key: "clinic_code");
    print(cliniccode);

    try {
      FormData formData = FormData.fromMap(
          {"avatar": await MultipartFile.fromFile(filePath, filename: "dp")});

      Response response =
          await Dio().put("'http://10.0.2.2:8000/api/v1/user/'$id",
              data: formData,
              options: Options(headers: <String, String>{
                'Authorization': 'JWT $myJwt',
              }));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {}
  }
}
