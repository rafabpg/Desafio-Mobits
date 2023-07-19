import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FieldTrasnsferencia extends StatelessWidget {
   final TextEditingController controllerAccount;
   final TextEditingController controllervalue;
  final String labelTextAccount;
  final String labelTextValue;
  final String buttonText;
  final VoidCallback onPressed;

  FieldTrasnsferencia({
    required this.controllerAccount,
    required this.controllervalue,
    required this.labelTextAccount,
    required this.labelTextValue,
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
                controller: controllerAccount,
                 style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
                decoration: InputDecoration(
                  labelText: labelTextAccount,
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
            Expanded(
              child: 
              Padding(
                padding: EdgeInsets.only(right:15,left:15),
                  child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controllervalue,
                   style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                  decoration: InputDecoration(
                    labelText: labelTextValue,
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
              ) 
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