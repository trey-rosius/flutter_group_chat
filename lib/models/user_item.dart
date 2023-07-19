class UserItem {
  String? email;
  String? id;
  String? username;
  String? profilePicKey;

  UserItem({this.email, this.id, this.username, this.profilePicKey});

  UserItem.fromJson(Map<String, dynamic> json) {
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