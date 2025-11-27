import 'active_memberships.dart';

class MembershipListCategoryModel {
  List<ActiveMemberships> activeMemberships;
  List<MembershipCategory> membershipCategories;

  MembershipListCategoryModel(
      {required this.activeMemberships, required this.membershipCategories});
}

class MembershipCategory {
  int? id;
  int? clubId;
  String? categoryName;

  MembershipCategory({this.id, this.clubId, this.categoryName});

  MembershipCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['club_id'] = this.clubId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class ShowMembershipCategory {
  List<int> id = [];
  String? categoryName;

  ShowMembershipCategory({this.categoryName});

  ShowMembershipCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].cast<int>();
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}
