import 'package:app_desafio/controller/userController.dart';
import 'package:app_desafio/services/authService.dart';
import 'package:app_desafio/services/userService.dart';
import 'package:app_desafio/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  String _account = '';
  String _password = '';
  bool _passwordVisibility = true;
  
 late UserController _userController;

  @override
  void initState(){
    super.initState();
     _userController = UserController(context,UserService());
  }

  _submitLogin() async{
    print("Entrou no Login");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if( await _userController.login(_account,_password)){
          print("Usuario LOGADO");
          Navigator.pushReplacementNamed(context, '/bankAccount');
        }else{
          await showDialogPopUp(context,'Campos incorreto','Erro no preenchimento dos campos');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF424549)
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      labelText: 'Conta Corrente',
                      labelStyle: TextStyle(
                        color: Colors.orange, 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange, // Set the desired hexadecimal focus color here
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red, // Defina a cor da borda de erro
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua Conta Corrente';//widget de Erro
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: ((newValue)  {
                      _account = newValue!;
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    obscureText: _passwordVisibility,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      labelText: 'Senha',
                      labelStyle: TextStyle(
                        color: Colors.orange, 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange, // Set the desired hexadecimal focus color here
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red, // Defina a cor da borda de erro
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisibility = !_passwordVisibility;
                          });
                        },
                        child: Icon(
                          _passwordVisibility ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ), 
                    ),
                    style: TextStyle(
                      color: Colors.white
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua senha';//widget de Erro
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction, 
                    onSaved: ((newValue)  {
                      _password = newValue!;
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed:_submitLogin ,
                    style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.orange , // Set the button background color
                          foregroundColor: Color(0xFF424549), // Set the button text color
                          textStyle: TextStyle(fontSize: 16), // Set the button text style
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Set the button border radius
                          ),
                          elevation: 4, // Set the button elevation (shadow)
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                  )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}