import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final Function onChange;
  final bool isChecked;
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;


  const CustomCheckbox(
      {super.key,  required this.isChecked,
        required this.onChange,
        required  this.size,
        required  this.iconSize,
        required  this.selectedColor,
        required this.selectedIconColor,
        required this.borderColor,
        });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange(_isSelected);
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
                // Color(0XFFfee140)

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