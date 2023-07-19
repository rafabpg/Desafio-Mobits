import 'package:app_desafio/exceptions/userNotFound.dart';
import 'package:app_desafio/helper/errorHandler.dart';
import 'package:app_desafio/models/transacoes.dart';
import 'package:app_desafio/models/user.dart';
import 'package:app_desafio/providers/userState.dart';
import 'package:app_desafio/services/authService.dart';
import 'package:app_desafio/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserController with ChangeNotifier{
  final UserService _userService ;
  final BuildContext context;
  // UserController(this._userService);
  UserController(this.context, this._userService);

  Future<bool> login(String account,String password) async {
    try {
      bool validation = AuthService.validateLogin(account,password);
      if(validation){
        User ?checkingIfUserExist = await _userService.getUserByAccount(account);
        if(checkingIfUserExist == null){
          return false;
        }else{
          Provider.of<UserState>(context, listen: false).login(checkingIfUserExist);
          notifyListeners();
          return true;
        }
      }else{
        return false;
      }
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
    throw Exception("Um erro aconteceu ao tentar fazer o login");
    
  }

  Future<void> logout() async {
    try {
      Provider.of<UserState>(context, listen: false).logout();
      notifyListeners(); 
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<double> gettingSaldo(String account) async {
    try {
      double mySaldo = await _userService.getUserSaldo(account);
      return mySaldo;
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
    throw Exception("Um erro aconteceu ao tentar pegar o saldo");
  }

  Future<List<Transacoes>?> myExtrato(String account) async {
    try {
      List<Transacoes> ?transacoes = await _userService.gettingAllTransactions(account);
      return transacoes;
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
    throw Exception("Um erro aconteceu ao tentar pegar as transações");
  }

  Future<void> deposito(String account,double newValue,String tipo) async {
    try {
      await _userService.realizarDeposito(account, newValue, tipo);
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }   
  }

  //tem que ter um exception
  Future<bool?> transferencia(String account,double newValue,String tipo,String destineAccount,String perfil) async {
    try {
      await _userService.realizarTransferencia( account, newValue, tipo,destineAccount, perfil);
      return true;
    } catch (error) {
      if(error is Exception){
        UserNotFound(error.toString());
        print("false");
        return false;
      }
      ErrorHandler.handleError(context, error);
      return false;
    }
  }
  // arrumar
  Future<void> saque(String account,double newValue) async {
    try {
      await _userService.realizarSaque( account, newValue);
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<void> visitaGerente(String account) async {
    try {
      await _userService.visitaDoGerente( account);
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<void> inserirTaxa(String account,double taxa) async {
    try {
      await _userService.inserirTaxa( account,taxa);
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

}