import 'package:dio/dio.dart';
import 'package:testapp/models/index.dart';
import 'package:testapp/shared/api/apiClient.dart';
import 'package:testapp/shared/constants/const.dart';

class ApiService extends ApiClient {
  /// TODO: USE YOUR OWN MODEL
  static Future<List<TodoModel>> get getPosts async {
    try {
      Response response =
          await ApiClient.get(endpoint: AppConstants.todoEndpoint);
      TodoModel.fromList(response.data);

      return TodoModel.fromList(response.data);
    } catch (err, stacktarce) {
      print("API SERVICE GET ERROR : $err");
      print(stacktarce);
      return null;
    }
  }

  static Future<bool> newPost(Map<String, dynamic> body) async {
    try {
      print("sending POSTS...");

      print(body);
      Response response =
          await ApiClient.post(endpoint: AppConstants.todoEndpoint, body: body);
      print("Finished POSTS... ${response.statusCode})");

      if (response.statusCode == 201) print(response.data);
      return response.statusCode == 201;
    } catch (err) {
      print("API SERVICE POST ERROR: $err");
      return false;
    }
  }
}
