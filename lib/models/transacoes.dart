import 'package:app_desafio/models/user.dart';

class Transacoes{
  int ?id;
  int userId;
  String date;
  String description;
  double amount;

  static final  tableName = "transacoes";

  Transacoes({
    this.id,
    required this.userId,
    required this.date,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  static Transacoes fromMap(Map<String, dynamic> map) {
    return Transacoes(
      id: map['id'],
      userId: map['userId'],
      date: map['date'],
      description: map['description'],
      amount: map['amount'],
    );
  } 

}