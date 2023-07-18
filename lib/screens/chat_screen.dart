import 'dart:convert';
import 'dart:ui';



import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:group_chat/screens/left_chat_screen.dart';
import 'package:group_chat/screens/right_chat_screen.dart';
import 'package:group_chat/screens/typing_indicator.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';


import 'dart:io';

import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen(this.username, {super.key});
  final String username;



  @override
  State createState() =>
      GroupChatScreenState();
}

class GroupChatScreenState extends State<GroupChatScreen> {

  bool _isSomeoneTyping = false;
  final greyColor = Color(0xffaeaeae);
  bool update = false;
  String chatId="";

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
  List<Map> chatMessagesList = [];

  late final Stream<GraphQLResponse<String>> operation;
  late final Stream<GraphQLResponse<String>> sendMessageStream;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();

    listScrollController = new ScrollController();
    isLoading = false;

    subscribeToTyping();
    subscribeToSendMessage();
  }

  @override
  void dispose(){
    // Clean up the focus node when the Form is disposed.
    myFocusNode!.dispose();
    textEditingController.dispose();


    super.dispose();


  }

  Future<bool> sendMessage(String groupId,String messageText,String userId) async {






    try {
      String graphQLDocument =
      '''
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

              "groupId":groupId,

              "messageText":messageText,
              "userId":userId,

            },
          ));

      var response = await operation.response;

      var data = response.data;
      if(response.data != null){

        Map value = json.decode(response.data!);
        if (kDebugMode) {
          print('Mutation result is' + data!);


        }
        return true;
      }else{

        print('Mutation error: ' + response.errors.toString());

        return false;
      }







    } catch (ex) {

      print(ex.toString());

      return false;

    }


  }



  Future<bool> typingIndicator(String userId,String groupId,bool typing) async {






    try {
      String graphQLDocument =
      '''
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

              "typing":typing,

              "groupId":groupId,
              "userId":userId,

            },
          ));

      var response = await operation.response;

      var data = response.data;
      if(response.data != null){
        if (kDebugMode) {
          print('Mutation result is' + data!);


        }
        return true;
      }else{

        print('Mutation error: ' + response.errors.toString());

        return false;
      }







    } catch (ex) {

      print(ex.toString());

      return false;

    }


  }

  Future<void> subscribeToSendMessage() async {
    const graphQLDocument = r'''
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
        apiName: "cdk-group_chat-api_API_KEY",

      ),
      onEstablished: () => print('Subscription established'),
    );


    try {


      await for (var event in sendMessageStream) {

        Map value = json.decode(event.data!);

        if (kDebugMode) {
          print("event data is ${value["newMessage"]}");
        }
       if(chatMessagesList.isNotEmpty){
         if(chatMessagesList[0]['id'] != value['newMessage']['id']){

           setState(() {
             chatMessagesList.insert(0, value['newMessage']);
           });
         }

       }else{
         setState(() {
           chatMessagesList.insert(0, value['newMessage']);
         });
       }
        print("all list messages are ${chatMessagesList}");






        // print("map is ${map["typingIndicator"]}");
        print('Subscription event data received: ${event.data}');
      }
    } on Exception catch (e) {
      print('Error in subscription stream: $e');
    }
  }



  Future<void> subscribeToTyping() async {
    const graphQLDocument = r'''
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
        apiName: "cdk-group_chat-api_API_KEY",

      ),
      onEstablished: () => print('Subscription established'),
    );


    try {


      await for (var event in operation) {

        Map value = json.decode(event.data!);

       print("event data is ${value['typingIndicator']}");

       if(value['typingIndicator']['userId'] == widget.username)
         {

           print("can't show typing indicator for me");
         }else{

         setState(() {
           _isSomeoneTyping =value['typingIndicator']['typing'];
         });

       }





       // print("map is ${map["typingIndicator"]}");
        print('Subscription event data received: ${event.data}');
      }
    } on Exception catch (e) {
      print('Error in subscription stream: $e');
    }
  }









  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    final platform = Theme.of(context).platform;

    return  Scaffold(
      backgroundColor: const Color(0xFF1e1d2d),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Chat Screen",style: TextStyle(color: Colors.black),
      ),),


        body:  Column(
          children: <Widget>[


         Flexible(child: ListView.builder(
           itemCount: chatMessagesList.length,
             reverse: true,
             itemBuilder: (context,index){
             return
                 widget.username == chatMessagesList[index]['userId'] ?
                     RightChatScreen(message:chatMessagesList[index]) :LeftChatScreen(message: chatMessagesList[index],);

         }),),

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
        )
    );



  }



  Widget buildInput() {

    return
      Container(
        padding: EdgeInsets.only(bottom: 20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                isLoading ?
                Container(
                    height: 20.0,
                    width: 20.0,
                    margin:EdgeInsets.only(right: 20.0),
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
                            decoration:  InputDecoration(
                              fillColor: Colors.white,
                              labelText: "Say Something ....",
                              contentPadding: new EdgeInsets.all(18.0),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              floatingLabelStyle: const TextStyle(color: Colors.black),
                              border:  OutlineInputBorder(
                                  borderSide:  const BorderSide(
                                      width: 2.0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: (Colors.grey.withOpacity(0.2)), width: 2),
                                  borderRadius: BorderRadius.circular(300)
                              ),

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 2),

                                  borderRadius: BorderRadius.circular(30)


                              ),

                            ),
                            onChanged: (String text) {

                              if (text.trim().isNotEmpty) {

                                typingIndicator(widget.username,'groupIdadnasdad',true);
                              } else {

                                typingIndicator(widget.username,'groupIdadnasdad',false);

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
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  child: Center(
                    child: IconButton(
                      icon: new Icon(Icons.arrow_forward),
                      onPressed: (){
                        sendMessage('GroupText',textEditingController.text,widget.username);
                        textEditingController.clear();
                        typingIndicator(widget.username,'groupIdadnasdad',false);
                      }

                    ),
                  ),
                ),

              ],


            ),
          ],
        ),
      );
  }
}
