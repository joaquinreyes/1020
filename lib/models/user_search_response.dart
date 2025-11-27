import 'package:hop/models/app_user.dart';

class UserSearchResponse {
  bool? success;
  String? message;
  UserSearchData? data;

  UserSearchResponse({this.success, this.message, this.data});

  UserSearchResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserSearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserSearchData {
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  List<User>? customers;

  UserSearchData({
    this.totalRecords,
    this.totalPages,
    this.currentPage,
    this.customers,
  });

  UserSearchData.fromJson(Map<String, dynamic> json) {
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    if (json['customers'] != null) {
      customers = <User>[];
      json['customers'].forEach((v) {
        customers!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalRecords'] = totalRecords;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    if (customers != null) {
      data['customers'] = customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
