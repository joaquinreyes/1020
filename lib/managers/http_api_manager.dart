import 'dart:convert';
import 'package:hop/globals/api_endpoints.dart';
import 'package:hop/managers/api_manager.dart';
import 'package:hop/managers/user_manager.dart';
import 'package:hop/screens/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../globals/constants.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class HttpApiManager {
  Future<dynamic> post(Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      List<String> pathParams = const [""],
      Map<String, dynamic>? queryParams,
      bool isV2Version = false}) async {
    try {
      String url = endpoint.isWithoutClub
          ? "$kBaseURL/${endpoint.path(id: pathParams)}"
          : "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      if (queryParams != null && queryParams.isNotEmpty) {
        final stringParams = queryParams.map((key, value) {
          if (value is List ||
              value is Set ||
              value is Iterable ||
              value is Map) {
            return MapEntry(key, value.join(','));
          } else {
            return MapEntry(key, value.toString());
          }
        });
        url += '?${Uri(queryParameters: stringParams).query}';
      }

      final headers = {
        'Content-Type': 'application/json',
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };
      myPrint("-------------------- Post Request Api ---------------");
      myPrint(url);
      myPrint(data);
      myPrint(headers);
      myPrint("-----------------------------------");
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patch(
      Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      String url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      final headers = {
        'Content-Type': 'application/json',
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };
      myPrint("-------------------- Patch Request Api ---------------");
      myPrint(url);
      myPrint(data);
      myPrint(headers);
      myPrint("-----------------------------------");
      final response = await http.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> put(Ref ref, ApiEndPoint endpoint, Map<String, dynamic> data,
      {String? token,
      List<String> pathParams = const [""],
      Map<String, dynamic>? queryParams,
      bool isV2Version = false}) async {
    try {
      String url = endpoint.isWithoutClub
          ? "$kBaseURL/${endpoint.path(id: pathParams)}"
          : "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      if (queryParams != null && queryParams.isNotEmpty) {
        final stringParams = queryParams.map((key, value) {
          if (value is List ||
              value is Set ||
              value is Iterable ||
              value is Map) {
            return MapEntry(key, value.join(','));
          } else {
            return MapEntry(key, value.toString());
          }
        });
        url += '?${Uri(queryParameters: stringParams).query}';
      }

      final headers = {
        'Content-Type': 'application/json',
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };
      myPrint("-------------------- Put Request Api ---------------");
      myPrint(url);
      myPrint(data);
      myPrint(headers);
      myPrint("-----------------------------------");
      final response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(data));

      myPrint("-------------------- Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> get(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic> queryParams = const {},
      String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      String url = endpoint.isWithoutClub
          ? "$kBaseURL/${endpoint.path(id: pathParams)}"
          : "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      if (endpoint.isWebSocketUrl) {
        url = "$kChatBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      }

      if (queryParams.isNotEmpty) {
        final stringParams = queryParams.map((key, value) {
          if (value is List ||
              value is Set ||
              value is Iterable ||
              value is Map) {
            return MapEntry(key, value.join(','));
          } else {
            return MapEntry(key, value.toString());
          }
        });
        url += '?${Uri(queryParameters: stringParams).query}';
      }

      final headers = {
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };
      myPrint("-------------------- Get Request Api ---------------");
      myPrint(url);
      myPrint(headers);
      myPrint("-----------------------------------");
      final response = await http.get(Uri.parse(url), headers: headers);

      myPrint("-------------------- Get Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> patchMultipart(Ref ref, ApiEndPoint endpoint,
      {Map<String, dynamic>? multipartData,
      String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      String url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      final request = http.MultipartRequest('PATCH', Uri.parse(url))
        ..headers.addAll({
          if (endpoint.isAuthRequired && token != null)
            'Authorization': 'Bearer $token',
        });
      multipartData?.forEach((key, value) {
        if (key == "image") {
          request.files.add(value);
        } else {
          request.fields[key] = value.toString();
        }
      });
      myPrint(
          "-------------------- Patch Multi part Request Api ---------------");
      myPrint(url);
      myPrint(request.fields);
      myPrint(request.files.length);
      myPrint("-----------------------------------");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      myPrint(
          "-------------------- Patch Multi part Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  Future<dynamic> delete(Ref ref, ApiEndPoint endpoint,
      {String? token,
      List<String> pathParams = const [""],
      bool isV2Version = false}) async {
    try {
      String url = "$kBaseURL/$kClubID/${endpoint.path(id: pathParams)}";
      url = isV2Version ? url.replaceFirst("v1", "v2") : url;

      final headers = {
        if (endpoint.isAuthRequired && token != null)
          'Authorization': 'Bearer $token',
      };
      myPrint("-------------------- Delete Request Api ---------------");
      myPrint(url);
      myPrint(headers);
      myPrint("-----------------------------------");
      final response = await http.delete(Uri.parse(url), headers: headers);
      myPrint("-------------------- Delete Response Api ---------------");
      myPrint(response.statusCode.toString());
      myPrint(response.body);
      myPrint("-----------------------------------");
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw response;
      }

      if (response.statusCode == endpoint.successCode) {
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    } catch (e) {
      _handleError(e, ref, endpoint, pathParams);
    }
  }

  void _handleError(
      dynamic error, Ref ref, ApiEndPoint endpoint, List<String> pathParams) {
    if (!kIsWeb) {
      ref.read(crashlyticsProvider).recordError(
          Exception(
              "Error while making request to ${endpoint.path(id: pathParams)}: $error"),
          StackTrace.current);
    }
    if (error is http.Response &&
        (error.statusCode == 401 || error.statusCode == 403)) {
      ref.read(userManagerProvider).signOut(ref);
      final goRouter = ref.read(goRouterProvider);
      final currentRoute =
          goRouter.routerDelegate.currentConfiguration.fullPath;
      if (currentRoute != RouteNames.auth) {
        goRouter.push(RouteNames.auth);
      }
      throw 'Session expired';
    }
    if (error is http.Response && error.statusCode == 502) {
      throw "Technical Issue";
    }
    if (error is http.ClientException) {
      if (error.message.contains("Connection reset by peer")) {
        throw "Technical Issue";
      } else if (error.message.contains("error code: 502")) {
        throw "Technical Issue";
      }
    }
    throw error;
  }
}
