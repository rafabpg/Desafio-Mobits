import 'package:app_desafio/controller/userController.dart';
import 'package:app_desafio/providers/userState.dart';
import 'package:app_desafio/utils/show_dialog.dart';


Future<void> realizarSaque(UserController userController, String account, double valorSaque, String perfil , Function() atualizarSaldoCallback,Function() atualizarExtratoCallback) async {
  if (perfil == "NORMAL" ) {
    double saldoAtualNormal = await userController.gettingSaldo(account);
    if(saldoAtualNormal != null && valorSaque.abs() <= saldoAtualNormal){
      await userController.saque(account, valorSaque);
      atualizarSaldoCallback();
      atualizarExtratoCallback();
    }
  } else if(perfil == "VIP"){
    double saldoAtual = await userController.gettingSaldo(account);
    if(saldoAtual!= null){
      if ( valorSaque.abs() <= saldoAtual) {
        print("entrou no if");
        await userController.saque(account, valorSaque);
        atualizarSaldoCallback();
        atualizarExtratoCallback();
      }else{
        double valorFaltante = valorSaque.abs() - saldoAtual;
        await userController.saque(account, valorSaque);
        atualizarSaldoCallback();
        atualizarExtratoCallback();
        while(valorFaltante > 0){
          print("entrou no loop");
          await Future.delayed(Duration(minutes: 1));
          saldoAtual = await userController.gettingSaldo(account);
          if(saldoAtual >= 0){
            print("entrou no saldo 0 ");
            return;
          }else{
            print("entrou no saldo negativo");
            print(valorFaltante);
            double taxaReducao = valorFaltante * 0.001;
            await userController.inserirTaxa(account,taxaReducao);
            atualizarSaldoCallback();
          }
        }
      }
    }
  }   
}


Future<void> realizarDeposito(UserController userController, String account, String valorDeposito,  Function() atualizarSaldoCallback,Function() atualizarExtratoCallback,context) async {
  if( valorDeposito != ''){  
      await userController.deposito(account,double.parse(valorDeposito), "DEPOSITO");
      print("entrou no certo");
      atualizarSaldoCallback();
      atualizarExtratoCallback();
      await showDialogPopUp(context, 'Deposito', 'Deposito realizado com Sucesso');
  }else{
    print("entrou no erro");
    await showDialogPopUp(context, 'Deposito', 'Falha ao realizar o deposito');
  }
}


Future<void> realizarTransferencia(UserController userController, String account,String destineAccount, String valorTrasnf,  Function() atualizarSaldoCallback,Function() atualizarExtratoCallback,perfil,context) async {
    if(perfil == "NORMAL" && account != destineAccount && (double.parse(valorTrasnf))<=1000){
       bool? confirmation = await userController.transferencia(
          account,
          double.parse(valorTrasnf)*-1,
          "TRANSFERENCIA", 
          destineAccount, 
          perfil
        );
        if(confirmation != null && confirmation == true){
          atualizarSaldoCallback();
          atualizarExtratoCallback();
          await showDialogPopUp(context, 'Transferencia', 'Transferencia realizada com sucesso');
        }else{
         await showDialogPopUp(context, 'Transferencia', 'Falha ao realizar a transferencia');
        }
          
    }else if(perfil == "VIP" && account != destineAccount){
       bool? confirmation = await userController.transferencia(
          account,
          double.parse(valorTrasnf)*-1,
          "TRANSFERENCIA", 
          destineAccount, 
          perfil
        );
        if(confirmation !=null && confirmation){
          atualizarSaldoCallback();
          atualizarExtratoCallback();
          await showDialogPopUp(context, 'Transferencia', 'Transferencia realizada com sucesso');
        }else{
        await showDialogPopUp(context, 'Transferencia', 'Falha ao realizar a transferencia');
        }
    }else{
     await showDialogPopUp(context, 'Transferencia', 'Falha ao realizar a transferencia');
    }
}