import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ethread_app/services/exceptions/app_exceptions.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  //GET

  Future<dynamic> get(String endpoint) async {
    // final String _token = await DartFunctions.getUserToken();
    var uri = Uri.parse("${Constants.baseUrl}$endpoint");

    try {
      final response = await http.get(uri, headers: {
        "Authorization": "Bearer " + Constants.userToken,
        "Accept": "application/json"
        
      }).timeout(const Duration(seconds: Constants.timeout));

      return _processResponse(response);
    } on TimeoutException {
      throw ApiNotRespondingException(Constants.timeOutErrorMessage, uri.toString());
    } on SocketException {
      throw FetchDataException(Constants.networkErrorMessage, uri.toString());
    }
  }

  //POST

  Future<dynamic> post(String endpoint, dynamic payload) async {
    // final String _token = await DartFunctions.getUserToken();
    var uri = Uri.parse("${Constants.baseUrl}$endpoint");
    var body = jsonEncode(payload);

    try {
      final response = await http
          .post(uri,
              headers: {
                "Authorization": "Bearer " + Constants.userToken,
                "Content-Type": "application/json",
                "Accept": "application/json"
              },
              body: body)
          .timeout(const Duration(seconds: Constants.timeout));

      return _processResponse(response);
    } on TimeoutException {
      throw ApiNotRespondingException(Constants.timeOutErrorMessage, uri.toString());
    } on SocketException {
      throw FetchDataException(Constants.networkErrorMessage, uri.toString());
    }
  }

  //POST with Form-Data for BinReportSubmission API
  Future<dynamic> binReportPostForm(
      String endpoint, Map<String, dynamic> payloadFormParams) async {
    // final String _token = await DartFunctions.getUserToken();
    var uri = Uri.parse("${Constants.baseUrl}$endpoint");

    try {
      var headers = {'Authorization': 'Bearer ' + Constants.userToken,"Accept": "application/json"};
      var request = http.MultipartRequest('POST', uri);

      payloadFormParams.forEach((key, value) async {
        if (key == 'bins') {
          var index = -1;
          for (var element in value) {
            index++;

            element.cast<String, dynamic>().forEach((key, value) async {
              if (key == "first_picture" || key == "last_picture" ||(key == "audio" && value != null)) {
                request.files
                    .add(await http.MultipartFile.fromPath("bins[$index][$key]", value));
              } else {
                request.fields.addAll({
                  "bins[$index][$key]":
                      value is int ? value.toString() : value == null ? '' : value.toString(),
                });
              }
            });
          }
        } else {
          request.fields.addAll({key: value});
        }
      });

      request.headers.addAll(headers);
      final response = await http.Response.fromStream(await request.send())
          .timeout(const Duration(seconds: Constants.timeout));

      // print('API: $endpoint Response Status Code ${response.statusCode}');
      return _processResponse(response);
    }  on TimeoutException {
      throw ApiNotRespondingException(Constants.timeOutErrorMessage, uri.toString());
    } on SocketException {
      throw FetchDataException(Constants.networkErrorMessage, uri.toString());
    } catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'To get the crash report');
      rethrow;
    }
  }

  //DELETE

  Future<dynamic> delete(String endpoint) async {
    // final String _token = await DartFunctions.getUserToken();
    var uri = Uri.parse("${Constants.baseUrl}$endpoint");

    try {
      final response = await http.delete(
        uri,
        headers: {"Authorization": "Bearer " + Constants.userToken},
      ).timeout(const Duration(seconds: Constants.timeout));

      return _processResponse(response);
    } on TimeoutException {
      throw ApiNotRespondingException("", uri.toString());
    } on SocketException {
      throw FetchDataException("", uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw ValidationException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            "Error occurred with code : ${response.statusCode}",
            response.request!.url.toString());
    }
  }
}
