import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: '',
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type': 'application/json',
        'lang': 'ar',
      },
    ));
  }

  static Future<Response> getData(
      { url,  query, lang, token}) async {
    ///TODo: this bloc of code is unSuccess
    dio!.options.headers = {
      'lang': lang,
      'Content-Type': 'application/json',
      'Authorization': token ?? null,
    };
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {@required url, query,@required data, lang = 'en', token}) async {
    ///TODo: this bloc of code is unSuccess
    dio!.options.headers = {
      'lang': lang,
      'Content-Type': 'application/json',
      'Authorization': token ?? null,
    };
    return await dio!.post(url, queryParameters: query, data: data);
  }
}