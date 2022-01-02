import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_mvvm_app/src/model/apis/api_exceptions.dart';
import 'package:simple_mvvm_app/utils/constants.dart';
class MedicineDataProvider{
  final http.Client httpClient;

  MedicineDataProvider({required this.httpClient,});

  Future<dynamic> getAllMeMedicines()async{
    late dynamic _apiResponse;
    try {
      final _jsonResponse = await httpClient.get(Uri.parse(medicineEndpoint),);
      _apiResponse = returnResponse(_jsonResponse);
    } on SocketException catch (e) {
      throw FetchDataException("No Internet Connection");
    }
    return _apiResponse;
  }

 @visibleForTesting
  dynamic returnResponse(http.Response response) {
     switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}