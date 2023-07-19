import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmação'),
        content: Text('Deseja confirmar esta ação?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); 
            },
            child: Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); 
            },
            child: Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

Future<void> showDialogPopUp(BuildContext context,title,content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o alerta
                },
              ),
            ],
          );
    },
  );
}