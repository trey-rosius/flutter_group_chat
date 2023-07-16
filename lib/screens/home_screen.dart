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

class HomeScreen extends StatefulWidget {
  HomeScreen(this.email);
  final String email;



  @override
  State createState() =>
      HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  bool update = false;
  String chatId="";



  @override
  void initState() {
    super.initState();



  }

  @override
  void dispose(){

    super.dispose();


  }












  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;



    return  Scaffold(
      backgroundColor: const Color(0xFF1e1d2d),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Chat Screen",style: TextStyle(color: Colors.black),
      ),),


        body:  const Column(
          children: <Widget>[


          ],
        )
    );



  }

}
