import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


class RightChatScreen extends StatelessWidget {
  RightChatScreen( {required this.message});
  final String message;


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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
padding: EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                      ),
                      width: 200.0,
                      child: Text(message,style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ],
            ),
          )

      );
  }
}
