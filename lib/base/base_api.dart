import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/utils/keys.dart';

import 'base_controllers.dart';

class BaseApi extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = Duration(seconds: 30);

    // Additional headers
    httpClient.addRequestModifier((Request request) {
      String token = GetStorage().read(storage_token) ?? '';
      request.headers['Authorization'] = 'Bearer $token';
      _print(doPrint: true, data: token);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }

  /// BASE FUNCTIONS
  Future<void> apiFetch({
    required String url,
    required BaseControllers controller,
    int code = 1,
    bool debug = false,
  }) async {
    try {
      _print(doPrint: debug, data: url);
      final response = await get('$url');
      _print(doPrint: debug, data: response.body);
      if (response.status.hasError) {
        return controller.loadFailed(
          requestCode: code,
          response: response,
        );
      }

      return controller.loadSuccess(requestCode: code, response: response.body, statusCode: response.status.code ?? 0);
    } catch (e) {
      print(e);
      // return controller.loadError(e);
    }
  }

  Future<void> apiPut({
    required String url,
    required BaseControllers controller,
    required Map data,
    int code = 1,
    bool debug = false,
  }) async {
    try {
      // print(url);
      _print(doPrint: debug, data: url);
      _print(doPrint: debug, data: data);
      final response = await put('$url', data);
      _print(doPrint: debug, data: response.body);

      if (response.status.hasError) {
        _print(doPrint: debug, data: 'Error : $url');
        return controller.loadFailed(
          requestCode: code,
          response: response,
        );
      }

      return controller.loadSuccess(requestCode: code, response: response.body, statusCode: response.status.code ?? 0);
    } catch (e) {
      // return controller.loadError(
      //   e,
      // );
    }
  }

  Future<void> apiPost({
    required String url,
    required BaseControllers controller,
    required Map data,
    int code = 1,
    bool debug = false,
  }) async {
    try {
      // print(url);
      _print(doPrint: debug, data: url);
      final response = await post('$url', data);
      _print(doPrint: debug, data: data);
      _print(doPrint: debug, data: response.body);

      if (response.status.hasError) {
        _print(doPrint: debug, data: 'Error : $url');
        return controller.loadFailed(
          requestCode: code,
          response: response,
        );
      }

      return controller.loadSuccess(requestCode: code, response: response.body, statusCode: response.status.code ?? 0);
    } catch (e) {
      print(e);
      // return controller.loadError(e);
    }
  }

  void _print({bool doPrint = false, dynamic data}) {
    if (doPrint) {
      try {
        log(json.encode(data));
      } catch (e) {
        log(data.toString());
      }
    }
  }
}
