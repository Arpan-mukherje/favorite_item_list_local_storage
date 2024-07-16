import 'dart:convert';
import 'package:favorite_item_list_local_storage/Models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setData(GetUserListResponseModel? responseModel) async {
    if (responseModel != null) {
      await preferences?.setString(
          "Favorite", jsonEncode(responseModel.toJson()));
    }
  }

  static GetUserListResponseModel? getData() {
    if (preferences?.getString("Favorite") != null) {
      return GetUserListResponseModel.fromJson(
          jsonDecode(preferences!.getString("Favorite")!));
    } else {
      return null;
    }
  }
}
