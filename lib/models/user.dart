class User{
  int? id;
  String account;
  String password;
  String perfil;
  double saldo;

   static final  tableName = "user";

  User({
    this.id,
    required this.account,
    required this.password,
    required this.perfil,
    required this.saldo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account': account,
      'password': password,
      'perfil': perfil,
      'saldo': saldo,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      account: map['account'],
      password: map['password'],
      perfil: map['perfil'],
      saldo: map['saldo'],
    );
  } 


}