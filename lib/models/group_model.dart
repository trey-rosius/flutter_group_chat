class GroupModel {
  GetAllGroupsCreatedByUser? getAllGroupsCreatedByUser;

  GroupModel({this.getAllGroupsCreatedByUser});

  GroupModel.fromJson(Map<String, dynamic> json) {
    getAllGroupsCreatedByUser = json['getAllGroupsCreatedByUser'] != null
        ? GetAllGroupsCreatedByUser.fromJson(
        json['getAllGroupsCreatedByUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getAllGroupsCreatedByUser != null) {
      data['getAllGroupsCreatedByUser'] =
          getAllGroupsCreatedByUser!.toJson();
    }
    return data;
  }
}

class GetAllGroupsCreatedByUser {
  List<Items>? items;
  String? nextToken;

  GetAllGroupsCreatedByUser({this.items, this.nextToken});

  GetAllGroupsCreatedByUser.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
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

class Items {
  String? description;
  String? id;
  String? name;
  String? userId;
  String? groupProfilePicKey;

  Items(
      {this.description,
        this.id,
        this.name,
        this.userId,
        this.groupProfilePicKey});

  Items.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    name = json['name'];
    userId = json['userId'];
    groupProfilePicKey = json['groupProfilePicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['name'] = name;
    data['userId'] = userId;
    data['groupProfilePicKey'] = groupProfilePicKey;
    return data;
  }
}
