import 'group_item.dart';
import 'group_items.dart';

class GroupCreatedByUserModel {
  GroupItems? groupItems;

  GroupCreatedByUserModel({this.groupItems});

  GroupCreatedByUserModel.fromJson(Map<String, dynamic> json) {
    groupItems = json['getAllGroupsCreatedByUser'] != null
        ? GroupItems.fromJson(
        json['getAllGroupsCreatedByUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (groupItems != null) {
      data['getAllGroupsCreatedByUser'] =
          groupItems!.toJson();
    }
    return data;
  }
}






