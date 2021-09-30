import 'dart:io';

import 'package:dio/dio.dart';

import 'PrintUtil.dart';

//网络请求工具类
class DioUtil {
  static const String TAG = 'DioUtil';
  static Dio _dio;
  static BaseOptions _options = new BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    contentType: ContentType.json.toString(),
    responseType: ResponseType.plain,
  );

  static get(String url, {options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      Response response = await dio.get(url, options: options);
      // PrintUtil.e(TAG, 'response:' + response.headers.toString());
      success(response.data);
    } catch (exception) {
      failure(exception);
    }
  }

  static getReturnResponse(String url,
      {options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      Response response = await dio.get(url, options: options);
      success(response);
    } catch (exception) {
      failure(exception);
    }
  }

  static post(String url,
      {params, options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      PrintUtil.e(TAG, 'options:${options.toString()}');
      Response response = await dio.post(url, data: params, options: options);
      success(response.data);
    } catch (exception) {
      failure(exception);
    }
  }

  static postReturnResponse(String url,
      {params, options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      Response response = await dio.post(url, data: params, options: options);
      success(response);
    } catch (exception) {
      failure(exception);
    }
  }

  static Dio buildDio() {
    if (_dio == null) {
      _dio = new Dio(_options);
//      _dio.interceptors.add(CookieManager(CookieJar()));
    }
    return _dio;
  }
}

//使用
//HttpUtlis.post("http://www.wanandroid.com/article/list/0/json", success: (value) {
//    print(value);
// }, failure: (error) {
//    print(error);
// });