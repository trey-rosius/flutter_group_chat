class GroupItem {
  String? description;
  String? id;
  String? name;
  String? userId;
  String? groupProfilePicKey;

  GroupItem(
      {this.description,
        this.id,
        this.name,
        this.userId,
        this.groupProfilePicKey});

  GroupItem.fromJson(Map<String, dynamic> json) {
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