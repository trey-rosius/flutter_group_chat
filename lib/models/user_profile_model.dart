import 'package:group_chat/models/user_item.dart';

class UserProfileModel {
  GetAllUserAccounts? getAllUserAccounts;

  UserProfileModel({this.getAllUserAccounts});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    getAllUserAccounts = json['getAllUserAccounts'] != null
        ? GetAllUserAccounts.fromJson(json['getAllUserAccounts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getAllUserAccounts != null) {
      data['getAllUserAccounts'] = getAllUserAccounts!.toJson();
    }
    return data;
  }
}

class GetAllUserAccounts {
  List<UserItem>? items;
  String? nextToken;

  GetAllUserAccounts({this.items, this.nextToken});

  GetAllUserAccounts.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <UserItem>[];
      json['items'].forEach((v) {
        items!.add(UserItem.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}


