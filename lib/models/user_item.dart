class UserItem {
  String? email;
  String? id;
  String? username;
  String? profilePicKey;
  String? createdOn;


  UserItem({this.email, this.id, this.username, this.profilePicKey,this.createdOn});

  UserItem.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    createdOn = json['createdOn'];
    id = json['id'];
    username = json['username'];
    profilePicKey = json['profilePicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['id'] = id;
    data['username'] = username;
    data['createdOn'] = createdOn;
    data['profilePicKey'] = profilePicKey;
    return data;
  }
}