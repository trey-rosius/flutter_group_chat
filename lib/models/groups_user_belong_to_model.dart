

import 'group_item.dart';

class GroupsUserBelongToModel {
  GetGroupsUserBelongsTo? getGroupsUserBelongsTo;

  GroupsUserBelongToModel({this.getGroupsUserBelongsTo});

  GroupsUserBelongToModel.fromJson(Map<String, dynamic> json) {
    getGroupsUserBelongsTo = json['getGroupsUserBelongsTo'] != null
        ? GetGroupsUserBelongsTo.fromJson(json['getGroupsUserBelongsTo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getGroupsUserBelongsTo != null) {
      data['getGroupsUserBelongsTo'] = getGroupsUserBelongsTo!.toJson();
    }
    return data;
  }
}

class GetGroupsUserBelongsTo {
  String? nextToken;
  List<Items>? items;

  GetGroupsUserBelongsTo({this.nextToken, this.items});

  GetGroupsUserBelongsTo.fromJson(Map<String, dynamic> json) {
    nextToken = json['nextToken'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nextToken'] = nextToken;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? createdOn;
  GroupItem? groupItem;
  String? userId;

  Items({this.createdOn, this.groupItem, this.userId});

  Items.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    groupItem = json['group'] != null ? GroupItem.fromJson(json['group']) : null;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    if (groupItem != null) {
      data['group'] = groupItem!.toJson();
    }
    data['userId'] = userId;
    return data;
  }
}


