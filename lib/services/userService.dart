import 'package:app_desafio/helper/databaseHelper.dart';
import 'package:app_desafio/models/transacoes.dart';
import 'package:app_desafio/models/user.dart';

class UserService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<User?> getUserByAccount(String account) async {
    User ?usuario = await _databaseHelper.getUser(account);
    if(usuario == null){
      return null;
    }
    return usuario;
  }

  Future<double> getUserSaldo(String account) async {
    double saldo = await _databaseHelper.getSaldoOfUser(account);
    if(saldo == 0.0){
      return 0.0;
    }
    return saldo;
  }

  Future<List<Transacoes>?> gettingAllTransactions(String account) async{
    User ?usuario = await getUserByAccount(account);
    if(usuario != null){
      List<Transacoes> transacoes  = await _databaseHelper.gettingTransacoes(usuario.id!);
      return transacoes;
    }
    return null;
  }

  Future<void> realizarDeposito(String account,double newValue,String tipo) async{
    User ?usuario = await getUserByAccount(account);
    if(usuario != null){
      await _databaseHelper.updateSaldoOfUser(account,usuario.saldo + newValue);
      Transacoes novaTransacao = Transacoes(
        userId: usuario.id!, 
        date: DateTime.now().toString(), 
        description: tipo, 
        amount:  newValue
      );
      await _databaseHelper.insertTransaccao(novaTransacao);
    }
  }

  Future<void> visitaDoGerente(String account) async{
    User ?usuario = await getUserByAccount(account);
    if(usuario != null){
      await _databaseHelper.updateSaldoOfUser(account,usuario.saldo-50); 
    }
  }


   Future<void> realizarTransferencia(String account,double newValue,String tipo,String destineAccount,String perfil) async{
    
      User ?cedente = await getUserByAccount(account);
      User ?sacante = await getUserByAccount(destineAccount);
      if(cedente != null && sacante != null){
        await _databaseHelper.updateSaldoOfUser(account,cedente.saldo - (newValue.abs() + 8));
        await _databaseHelper.updateSaldoOfUser(destineAccount,sacante.saldo + (newValue.abs()-(newValue.abs()*0.008)));
        Transacoes transacaoCedente = Transacoes(
          userId: cedente.id!, 
          date: DateTime.now().toString(), 
          description: tipo + " ENVIADA", 
          amount:  newValue
        );
        Transacoes transacaoSacante = Transacoes(
          userId: sacante.id!, 
          date: DateTime.now().toString(), 
          description: tipo + " RECEBIDA", 
          amount:  newValue.abs()
        );
        await _databaseHelper.insertTransaccao(transacaoCedente);
        await _databaseHelper.insertTransaccao(transacaoSacante);
    }else{
      throw Exception("Usuario não foi encontrado");
    }
  }

  // arrumar
  Future<void> realizarSaque(String account, double valorSaque) async {
    User ?usuario = await getUserByAccount(account);
    await _databaseHelper.updateSaldoOfUser(account,usuario!.saldo + valorSaque);
    Transacoes novaTransacao =  Transacoes(
          userId: usuario.id!, 
          date: DateTime.now().toString(), 
          description: "SAQUE", 
          amount: valorSaque
    );
    await _databaseHelper.insertTransaccao(novaTransacao);
  }

  Future<void> inserirTaxa(String account, double taxa) async {
    User ?usuario = await getUserByAccount(account);
    await _databaseHelper.updateSaldoOfUser(account,usuario!.saldo + (taxa)*-1 );
  }


}   