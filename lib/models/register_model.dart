import 'package:hop/globals/constants.dart';

class RegisterModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCode;
  String? password;
  double? level;
  List<double?> levelAnswers = [];
  String? profileImagePath;
  String? gamePreference;

  Map<String, dynamic> customFields = {
    // kStartedPlayingCustomID: DateTime.now().toIso8601String().split('T')[0],
    kPositionID: "",
    kTermsConditions: ""
  };

  // bool? get isOptInForMarketing =>
  //     customFields[kOptInForMarketingID] == "Yes" ? true : false;

  // set isOptInForMarketing(bool? value) {
  //   customFields[kOptInForMarketingID] = (value == true) ? "Yes" : "No";
  // }

  set playingSide(String? value) {
    customFields[kPositionID] = value;
  }

  set acceptTermsAndConditions(bool value) {
    if (value) {
      customFields[kTermsConditions] = "Accepted";
    }
  }

  String? get playingSide => customFields[kPositionID];

  // String? get playingSide => customFields[kPositionID];

  RegisterModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.level,
    this.password,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    customFields = json['custom_fields'];
  }

  Map<String, dynamic> toJson(String preferredSport) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneCode! + phoneNumber!;
    data['password'] = password;
    if (preferredSport.trim().toLowerCase() != "padel") {
      if (level != null) {
        data['default_level'] = level;
      }
      data['prefered_sport'] = preferredSport;
    }else{
      data['quiz_answers'] = levelAnswers.map((e) => e ?? 0).toList();
    }
    data['custom_fields'] = customFields;
    return data;
  }
}
