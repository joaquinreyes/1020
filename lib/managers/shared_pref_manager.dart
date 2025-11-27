import 'dart:convert';

import 'package:hop/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'shared_pref_manager.g.dart';

@Riverpod(keepAlive: true)
SharedPrefManager sharedPrefManager(SharedPrefManagerRef ref) {
  throw UnimplementedError();
}

class SharedPrefManager {
  static const String prefix = 'smash_padel`';
  static const String userKey = "${prefix}_user";
  static const String sportsName = "${prefix}_sport_name";
  static const String isSkip = "${prefix}_skip";
  static const String profilePictureDialogShown = "${prefix}_profile_dialog_shown";

  SharedPreferences prefs;
  SharedPrefManager(this.prefs);

  saveUser(AppUser user) async {
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  AppUser? fetchUser() {
    String? encodedString = prefs.getString(userKey);

    return encodedString != null
        ? AppUser.fromJson(jsonDecode(encodedString))
        : null;
  }

  setSportName(String sport) async {
    await prefs.setString(sportsName, sport);
  }

  getSportName() {
    return prefs.getString(sportsName);
  }

  setSkip(bool skip) async {
    await prefs.setBool(isSkip, skip);
  }

  bool getSkip() {
    return prefs.getBool(isSkip) ?? false;
  }

  setProfilePictureDialogShown(bool shown) async {
    await prefs.setBool(profilePictureDialogShown, shown);
  }

  bool hasProfilePictureDialogShown() {
    return prefs.getBool(profilePictureDialogShown) ?? false;
  }

  clearUser() async {
    await prefs.remove(userKey);
  }
}
