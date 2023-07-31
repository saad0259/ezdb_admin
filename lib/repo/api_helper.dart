import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// * Dio Start
enum Method { GET, POST, PATCH, DELETE }

const String baseUrl = 'https://5.9.88.108:5500/api/v1';

class Request {
  final String _url;
  final dynamic _body;

  Request(
    this._url,
    this._body,
  );

  Future<Response<dynamic>> _sendRequest(
    Method method,
    String baseUrl, {
    String? contentType,
  }) async {
    final dio = DioSingleton.instance.dio;

    try {
      log('Request: ${baseUrl + _url}');
      return await dio.request(
        baseUrl + _url,
        options: Options(
          method: _getMethodString(method),
          contentType: contentType,
        ),
        data: _body,
      );
    } catch (e) {
      log('Dio Error: $e');
      return Future.error(e);
    }
  }

  String _getMethodString(Method method) {
    switch (method) {
      case Method.GET:
        return 'GET';
      case Method.POST:
        return 'POST';
      case Method.PATCH:
        return 'PATCH';
      case Method.DELETE:
        return 'DELETE';
    }
  }

  Future<Response> get(String baseUrl) => _sendRequest(Method.GET, baseUrl);

  Future<Response> post(String baseUrl, {String? contentType}) =>
      _sendRequest(Method.POST, baseUrl, contentType: contentType);

  Future<Response> patch(String baseUrl) => _sendRequest(Method.PATCH, baseUrl);

  Future<Response> delete(String baseUrl) =>
      _sendRequest(Method.DELETE, baseUrl);
}

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio dio;
  static DioSingleton get instance => _instance;

  DioSingleton._internal() {
    const Duration timeout = Duration(seconds: 30);
    dio = Dio(BaseOptions(
      responseType: ResponseType.json,
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));
  }
}

// * Dio End

Future<T> executeSafely<T>(Future<T> Function() function) async {
  try {
    return await function();
  } on DioException catch (e) {
    // debugPrint(e.response?.data.toString());
    final String errorMessage =
        e.response?.data['message'] ?? 'Something went wrong. Please refresh.';
    log('Error: $errorMessage');

    throw errorMessage;
  } catch (e) {
    log('Error: $e');
    debugPrint(e.toString());
    return await executeSafely(function);
    // rethrow;
  }
}
