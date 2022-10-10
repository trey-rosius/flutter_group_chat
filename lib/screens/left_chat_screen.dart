import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


class LeftChatScreen extends StatelessWidget {
  LeftChatScreen({required this.message});
  final Map message;


     @override
  Widget build(BuildContext context) {
       var uuid =Uuid();
       var id = uuid.v1();
    return
      InkWell(
          onLongPress: (){

          },
          child:  Container(

            padding: EdgeInsets.all(10),
            child: Row(

              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(



                      width: 200.0,
                      padding: EdgeInsets.all(20),

                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      child:Text(message['messageText'],style: TextStyle(color: Colors.black),)),

                  ],
                ),
              ],
            ),
          )

      );
  }
}
