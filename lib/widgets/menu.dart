import 'package:app_desafio/controller/userController.dart';
import 'package:app_desafio/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Menu extends StatefulWidget {
  final UserController userController;

  Menu(this.userController);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Logout'),
            onTap: (){
              widget.userController.logout();
             Navigator.pushReplacementNamed(context, '/');
            }
          )
        ],
      ),
    );
  }
}