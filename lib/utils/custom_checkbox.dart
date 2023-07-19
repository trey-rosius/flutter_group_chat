import 'package:flutter/material.dart';
import 'package:group_chat/repos/group_repository.dart';

import '../models/user_item.dart';
class CustomCheckbox extends StatefulWidget {


  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;
  final GroupRepository groupRepository;
  final UserItem userItem;
  final String groupId;


  const CustomCheckbox(
      {super.key,

        required  this.size,
        required  this.iconSize,
        required  this.selectedColor,
        required this.selectedIconColor,
        required this.borderColor,
        required this.groupRepository,
        required this.userItem,
        required this.groupId
        });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
 bool _isSelected = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {



        widget.groupRepository.addUserToGroup(widget.userItem.id!, widget.groupId).then((value){
          setState(() {
            widget.groupRepository.userProfile = widget.userItem;
            _isSelected = value;
          });
        });


      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration:  BoxDecoration(
            gradient:_isSelected? LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xFFfa709a),
                Theme.of(context).primaryColor


              ],
            ):const LinearGradient(colors: [Colors.transparent,Colors.transparent]),

            borderRadius: BorderRadius.circular(300.0),
            border: Border.all(
              color: widget.borderColor ,
              width: 1.5,
            )),
        width: widget.size,
        height: widget.size,
        child: _isSelected
            ? Icon(
          Icons.check,
          color: widget.selectedIconColor,
          size: widget.iconSize,
        )
            : null,
      ),
    );
  }
}