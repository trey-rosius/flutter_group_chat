import 'package:group_chat/models/user_item.dart';


class GetAllUsersPerGroupModel {
  GetAllUsersPerGroup? getAllUsersPerGroup;

  GetAllUsersPerGroupModel({this.getAllUsersPerGroup});

  GetAllUsersPerGroupModel.fromJson(Map<String, dynamic> json) {
    getAllUsersPerGroup = json['getAllUsersPerGroup'] != null
        ? GetAllUsersPerGroup.fromJson(json['getAllUsersPerGroup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (getAllUsersPerGroup != null) {
      data['getAllUsersPerGroup'] = getAllUsersPerGroup!.toJson();
    }
    return data;
  }
}

class GetAllUsersPerGroup {
  String? nextToken;
  List<Items>? items;

  GetAllUsersPerGroup({this.nextToken, this.items});

  GetAllUsersPerGroup.fromJson(Map<String, dynamic> json) {
    nextToken = json['nextToken'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nextToken'] = nextToken;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  UserItem? userItem;
  String? createdOn;
  String? groupId;

  Items({this.userItem, this.createdOn, this.groupId});

  Items.fromJson(Map<String, dynamic> json) {
    userItem = json['user'] != null ? UserItem.fromJson(json['user']) : null;
    createdOn = json['createdOn'];
    groupId = json['groupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userItem != null) {
      data['user'] = userItem!.toJson();
    }
    data['createdOn'] = createdOn;
    data['groupId'] = groupId;
    return data;
  }
}


