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
  List<Items>? items;
  String? nextToken;

  GetAllUserAccounts({this.items, this.nextToken});

  GetAllUserAccounts.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? id;
  String? username;
  String? profilePicKey;

  Items({this.email, this.id, this.username, this.profilePicKey});

  Items.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    username = json['username'];
    profilePicKey = json['profilePicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['id'] = id;
    data['username'] = username;
    data['profilePicKey'] = profilePicKey;
    return data;
  }
}
