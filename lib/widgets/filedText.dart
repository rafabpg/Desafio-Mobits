import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FieldText extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String buttonText;
  final VoidCallback onPressed;

  FieldText({
    required this.controller,
    required this.labelText,
    required this.buttonText,
    required this.onPressed,
  });



  @override
  Widget build(BuildContext context) {
     return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600
              ),
              border: InputBorder.none,
              focusedBorder:UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              enabledBorder:UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),

        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
          style: ButtonStyle(
            backgroundColor:MaterialStateProperty.all<Color>(Colors.orange),
          ),
        ),
      ],
    );
  }
}