
import 'package:flutter/cupertino.dart';

import '../models/chat_item_model.dart';

class ChatRepository extends ChangeNotifier {
  ChatRepository.instance();

  List<ChatItemModel> _chatMessagesList = [];

  List<ChatItemModel> get chatMessagesList => _chatMessagesList;

  set chatMessagesList(List<ChatItemModel> value) {
    _chatMessagesList = value;
    notifyListeners();
  }

  set chatMessage(ChatItemModel value) {

    _chatMessagesList.insert(0, value);
    notifyListeners();
  }
}