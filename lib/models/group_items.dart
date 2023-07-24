import 'group_item.dart';

class GroupItems {
  List<GroupItem>? groupItemList;
  String? nextToken;

  GroupItems({this.groupItemList, this.nextToken});

  GroupItems.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      groupItemList = <GroupItem>[];
      json['items'].forEach((v) {
        groupItemList!.add(GroupItem.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (groupItemList != null) {
      data['items'] = groupItemList!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}