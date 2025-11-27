import 'membership_list_category_model.dart';

class MembershipModel {
  int? id;
  int? clubId;
  String? membershipName;
  String? duration;
  int? usesLimit;
  double? price;
  int? totalUses;
  String? currency;
  bool? appAvailable;
  int? membershipCategoryId;
  MembershipCategory? membershipCategory;
  String? description;
  List<Locations>? locations;

  int get locationId {
    if (locations != null && locations!.isNotEmpty) {
      return locations!.first.id ?? 0;
    }
    return 0;
  }

  String? get categoryName {
    return membershipCategory?.categoryName;
  }

  MembershipModel(
      {this.id,
      this.clubId,
      this.membershipName,
      this.duration,
      this.usesLimit,
      this.price,
      this.totalUses,
      this.currency,
      this.appAvailable,
      this.membershipCategory,
      this.membershipCategoryId,
      this.description,
      this.locations});

  MembershipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    membershipName = json['membership_name'];
    duration = json['duration'];
    usesLimit = json['uses_limit'];
    price = double.tryParse(json['price'].toString());
    totalUses = json['totalUses'];
    currency = json['currency'];
    appAvailable = json['app_available'];
    membershipCategory = json['membershipCategory'] != null
        ? MembershipCategory.fromJson(json['membershipCategory'])
        : null;
    membershipCategoryId = json['membership_category_id'];
    description = json['description'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['club_id'] = this.clubId;
    data['membership_name'] = this.membershipName;
    data['duration'] = this.duration;
    data['uses_limit'] = this.usesLimit;
    data['price'] = this.price;
    data['totalUses'] = this.totalUses;
    data['currency'] = this.currency;
    data['app_available'] = this.appAvailable;
    data['membership_category_id'] = this.membershipCategoryId;
    if (membershipCategory != null) {
      data['membershipCategory'] = membershipCategory!.toJson();
    }
    data['description'] = this.description;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int? id;
  String? locationName;

  Locations({this.id, this.locationName});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location_name'] = this.locationName;
    return data;
  }
}
