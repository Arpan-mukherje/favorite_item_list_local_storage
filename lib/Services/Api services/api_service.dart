import 'dart:convert';
import 'dart:developer';
import 'package:favorite_item_list_local_storage/Models/model.dart';
import 'package:favorite_item_list_local_storage/Services/Api%20services/api_urls.dart';
import 'package:favorite_item_list_local_storage/Services/Api%20services/base_api_services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<GetUserListResponseModel> fetchUsers(int index) async {
    GetUserListResponseModel? featureList;
    try {
      final response =
          await ApiBase.getRequest(extendedURL: "${ApiUrl.users}?page=$index");
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        featureList = getUserListResponseModelFromJson(response.body);
      } else {
        log("else");
        featureList = GetUserListResponseModel();
      }
    } catch (e) {
      log("Catch");
      featureList = GetUserListResponseModel();
    }

    return featureList;
  }
}
