import 'package:app_desafio/controller/userController.dart';
import 'package:app_desafio/providers/userState.dart';
import 'package:app_desafio/view/loginPage.dart';
import 'package:app_desafio/view/myBankPage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';



void main() {
   
  runApp(
    MyApp(),
  );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState(context)),
      ],
      child: MaterialApp(
        title: "Aplicativo do Banco",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/bankAccount': (context) => MyBankPage(),
        },
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return MyErrorWidget(errorDetails);
          };
          return child!;
        },
      ),
    );
  }
}

class MyErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  MyErrorWidget(this.errorDetails);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ocorreu um erro. Por favor, tente novamente mais tarde.',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
