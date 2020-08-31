import 'package:dio/dio.dart';
import 'package:testapp/shared/constants/const.dart';

class ApiClient {
  static Future post({String endpoint, Map<String, dynamic> body}) async {
    var dio = Dio();
    try {
      Response response =
          await dio.post("${AppConstants.core}$endpoint", data: body);
      return response;
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
      return null;
    }
  }

  static Future get({String endpoint}) async {
    var dio = Dio();

    try {
      Response response = await dio.get("${AppConstants.core}$endpoint");
      return response;
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
      return null;
    }
  }
}
