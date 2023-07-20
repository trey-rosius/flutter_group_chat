class ChatItemModel{
  NewMessage? newMessage;

  ChatItemModel({this.newMessage});

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    newMessage = json['newMessage'] != null
        ? NewMessage.fromJson(json['newMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (newMessage != null) {
      data['newMessage'] = newMessage!.toJson();
    }
    return data;
  }
}

class NewMessage {
  String? groupId;
  String? id;
  String? messageText;
  String? userId;

  NewMessage({this.groupId, this.id, this.messageText, this.userId});

  NewMessage.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    id = json['id'];
    messageText = json['messageText'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupId'] = groupId;
    data['id'] = id;
    data['messageText'] = messageText;
    data['userId'] = userId;
    return data;
  }
}
