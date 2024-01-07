import 'dart:convert';
import 'dart:ui';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:group_chat/models/chat_item_model.dart';
import 'package:group_chat/screens/left_chat_screen.dart';
import 'package:group_chat/screens/right_chat_screen.dart';
import 'package:group_chat/screens/typing_indicator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_item.dart';
import '../repos/chat_repository.dart';
import '../repos/profile_repository.dart';
import '../utils/utils.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen(this.username, {super.key});
  final String username;

  @override
  State createState() => GroupChatScreenState();
}

class GroupChatScreenState extends State<GroupChatScreen> {
  bool _isSomeoneTyping = false;
  final greyColor = const Color(0xffaeaeae);
  bool update = false;
  String chatId = "";

  final ImagePicker _picker = ImagePicker();

  FocusNode? myFocusNode;
  XFile? imageFile;
  File? audioFile;
  late bool isLoading;
  String? audioFilePath;
  String? imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  ScrollController? listScrollController;
  final FocusNode focusNode = FocusNode();

  String? fileExtension;


  late final Stream<GraphQLResponse<String>> operation;
  late final Stream<GraphQLResponse<String>> sendMessageStream;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();

    listScrollController = ScrollController();
    isLoading = false;

    subscribeToTyping();
    subscribeToSendMessage();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode!.dispose();
    textEditingController.dispose();


    super.dispose();
  }

  Future<bool> sendMessage(
      String groupId, String messageText, String userId) async {
    try {
      String graphQLDocument = '''
      mutation sendMessage(
            \$groupId: String!
            \$messageText: String!
    
            
            \$userId:String!
           ) {
  sendMessage(input: {

 groupId: \$groupId, 

  messageText: \$messageText, userId: \$userId}) {
     groupId
    id
    messageText
    userId
  }
}
      ''';

      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
        document: graphQLDocument,
        apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
        variables: {
          "groupId": groupId,
          "messageText": messageText,
          "userId": userId,
        },
      ));

      var response = await operation.response;

      var data = response.data;
      if (response.data != null) {
        Map value = json.decode(response.data!);
        if (kDebugMode) {
          print('Mutation result is${data!}');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Mutation error: ${response.errors}');
        }

        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> typingIndicator(
      String userId, String groupId, bool typing) async {
    try {
      String graphQLDocument = '''
      mutation create(
            \$groupId: String!
            \$userId: String!
    
            
            \$typing:Boolean!
           ) {
  typingIndicator(

 groupId: \$groupId, 

  userId: \$userId, typing: \$typing) {
  typing
  groupId
  userId
  }
}
      ''';

      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
        document: graphQLDocument,
        apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
        variables: {
          "typing": typing,
          "groupId": groupId,
          "userId": userId,
        },
      ));

      var response = await operation.response;

      var data = response.data;
      if (response.data != null) {
        if (kDebugMode) {
          print('Mutation result is${data!}');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Mutation error: ${response.errors}');
        }

        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<void> subscribeToSendMessage() async {

    var chatRepo = context.read<ChatRepository>();
    const graphQLDocument = '''
      subscription sendMessage {
      newMessage {
    groupId
    id
    messageText
    userId
  }
      }
    ''';

    sendMessageStream = Amplify.API.subscribe(
      GraphQLRequest<String>(
        document: graphQLDocument,
        apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
      ),
      onEstablished: () => print('Subscription established'),
    );

    try {
      await for (var event in sendMessageStream) {
        ChatItemModel chatItemModel =  ChatItemModel.fromJson(json.decode(event.data!));

        if (kDebugMode) {
          print("event message data is ${chatItemModel.newMessage!.messageText}");
        }
        if (chatRepo.chatMessagesList.isNotEmpty) {
          if (chatRepo.chatMessagesList[0].newMessage!.id != chatItemModel.newMessage!.id) {

              chatRepo.chatMessage =  chatItemModel;


          }
        } else {
          chatRepo.chatMessage = chatItemModel;

        }
        if (kDebugMode) {
        //  print("all list messages are $chatMessagesList");
          print('Subscription event data received: ${event.data}');
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error in subscription stream: $e');
      }
    }
  }

  Future<void> subscribeToTyping() async {
    const graphQLDocument = '''
      subscription typingIndicator {
        typingIndicator {
    groupId
    typing
    userId
  }
      }
    ''';

    operation = Amplify.API.subscribe(
      GraphQLRequest<String>(
        document: graphQLDocument,
        apiName: "cdk-group_chat-api_AMAZON_COGNITO_USER_POOLS",
      ),
      onEstablished: () => print('Subscription established'),
    );

    try {
      await for (var event in operation) {
        Map value = json.decode(event.data!);

        if (value['typingIndicator']['userId'] == widget.username) {
        } else {
          setState(() {
            _isSomeoneTyping = value['typingIndicator']['typing'];
          });
        }

        // print("map is ${map["typingIndicator"]}");
        if (kDebugMode) {
          print('Subscription event data received: ${event.data}');
        }
      }
    } on Exception catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var userProfileProvider = context.watch<UserItem?>();
    var chatRepo = context.watch<ChatRepository>();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/bg.jpeg',
              fit: BoxFit.cover,
            )),
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(left: 10, top: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              const Color(0xFFfa709a),
                              Theme.of(context).primaryColor
                              // Color(0XFFfee140)
                            ],
                          ),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              const Color(0xFFfa709a),
                              Theme.of(context).primaryColor
                              // Color(0XFFfee140)
                            ],
                          ),
                          shape: BoxShape.rectangle),
                      child: const Text("Splash waterfalls"),
                    ),
                  ],
                ),
              ),
            ),

            Flexible(
              child: ListView.builder(
                  itemCount: chatRepo.chatMessagesList.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return widget.username == chatRepo.chatMessagesList[index].newMessage!.userId
                        ? RightChatScreen(message: chatRepo.chatMessagesList[index].newMessage!.messageText!)
                        :  userProfileProvider != null
                                  ? FutureProvider<String?>.value(
                                      value: Utils.getDownloadUrl(
                                          key: userProfileProvider.profilePicKey!),
                                      initialData: '',
                                      child: Consumer(builder:
                                          (BuildContext context,
                                              String? profilePicUrl, child) {
                                        return LeftChatScreen(
                                          message: chatRepo.chatMessagesList[index].newMessage!.messageText!,
                                          profilePicUrl: profilePicUrl,
                                        );
                                      }))
                                  : SizedBox();

                  }),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: TypingIndicator(
                showIndicator: _isSomeoneTyping,
              ),
            ),

            // Sticker

            // Input content
            buildInput(),
          ],
        ),
      ],
    ));
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              isLoading
                  ? Container(
                      height: 20.0,
                      width: 20.0,
                      margin: EdgeInsets.only(right: 20.0),
                      child: CircularProgressIndicator())
                  : Container()
            ],
          ),
          Row(
            children: <Widget>[
              // Button send image

              // Edit text
              Flexible(
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                  //  padding: EdgeInsets.symmetric(vertical: 10.0),

                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          maxLines: null,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelText: "Say Something ....",
                            contentPadding: new EdgeInsets.all(18.0),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            floatingLabelStyle:
                                const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2.0, color: Colors.white),
                                borderRadius: BorderRadius.circular(100)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: (Colors.grey.withOpacity(0.2)),
                                    width: 2),
                                borderRadius: BorderRadius.circular(300)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onChanged: (String text) {
                            if (text.trim().isNotEmpty) {
                              typingIndicator(
                                  widget.username, 'groupIdadnasdad', true);
                            } else {
                              typingIndicator(
                                  widget.username, 'groupIdadnasdad', false);
                            }
                          },
                          focusNode: myFocusNode,
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                          controller: textEditingController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Button send message
              Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0xFFfa709a),
                        Theme.of(context).primaryColor
                        // Color(0XFFfee140)
                      ],
                    ),
                    shape: BoxShape.circle),
                child: Center(
                  child: IconButton(
                      icon: new Icon(Icons.arrow_forward),
                      onPressed: () {
                        sendMessage('GroupText', textEditingController.text,
                            widget.username);
                        textEditingController.clear();
                        typingIndicator(
                            widget.username, 'groupIdadnasdad', false);
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
