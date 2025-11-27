import 'package:hop/models/app_user.dart';

class FollowList {
  int? count;
  List<Following>? following;

  FollowList({this.count, this.following});

  FollowList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(new Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Following {
  int? id;
  int? followerId;
  int? followingId;
  String? createdAt;
  String? updatedAt;
  User? following;

  Following(
      {this.id,
        this.followerId,
        this.followingId,
        this.createdAt,
        this.updatedAt,
        this.following});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerId = json['follower_id'];
    followingId = json['following_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    following = json['following'] != null
        ? new User.fromJson(json['following'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['follower_id'] = this.followerId;
    data['following_id'] = this.followingId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.following != null) {
      data['following'] = this.following!.toJson();
    }
    return data;
  }
}

