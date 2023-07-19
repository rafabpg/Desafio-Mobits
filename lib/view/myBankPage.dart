import 'package:app_desafio/controller/userController.dart';
import 'package:app_desafio/models/transacoes.dart';
import 'package:app_desafio/providers/userState.dart';
import 'package:app_desafio/services/userService.dart';
import 'package:app_desafio/utils/bank_logic.dart';
import 'package:app_desafio/utils/show_dialog.dart';
import 'package:app_desafio/widgets/fieldTransferencia.dart';
import 'package:app_desafio/widgets/filedText.dart';
import 'package:app_desafio/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyBankPage extends StatefulWidget {
  const MyBankPage({super.key});

  @override
  State<MyBankPage> createState() => _MyBankPageState();
}

class _MyBankPageState extends State<MyBankPage> {
  //controller
  late UserController _userController;
  //controllers text fields
  TextEditingController _valorDepositoController = TextEditingController();
  TextEditingController _valorSaqueController = TextEditingController();
  TextEditingController _contaTrasnfController = TextEditingController();
  TextEditingController _valorTrasnfController = TextEditingController();
  //Minhas transações
  List<Transacoes> _transacoes = [];
  //meu saldo
  double _mySaldo = 0.0;
  //lista de possiveis ações que o usuario pode fazer
  String selectedAction = 'Ações';
  List<String> actions = ['Ações','Deposito', 'Saque', 'Transferencia','Gerente'];

  //inicialização
  @override
  void initState(){
    super.initState();
     _userController = UserController(context,UserService());
    _carregarSaldo();
    _carregarExtrato();
  }

  //carregamento do saldo
  Future<void> _carregarSaldo() async {
    UserState userState = Provider.of<UserState>(context, listen: false);
    String userAccount = userState.account;
    print(userState.perfil);
    double ?saldo = await _userController.gettingSaldo(userAccount);
    if(saldo != null){
      setState(() {
        _mySaldo = saldo;
      });
    }
  }
  //saque
  Future<void> _realizarSaque() async {
    UserState userState = Provider.of<UserState>(context, listen: false);
    String userAccount = userState.account;
    double value = double.parse(_valorSaqueController.text)*-1;
    _valorSaqueController.clear();
    await realizarSaque(_userController, userState.account,value , userState.perfil,_carregarSaldo,_carregarExtrato);
  }

  //carregamento do extrato
  Future<void> _carregarExtrato() async {
    UserState userState = Provider.of<UserState>(context, listen: false);
    String userAccount = userState.account;
    List<Transacoes> ?transacoes= await _userController.myExtrato(userAccount);
    if(transacoes != null){
      setState(() {
        _transacoes = transacoes;
      });
    }
  }
  //funcionalidade de solicitação de visita do gerente
  void _visitaDoGerente() async{
    bool? confirmado = await showConfirmationDialog(context);
    if (confirmado != null && confirmado) {
      UserState userState = Provider.of<UserState>(context, listen: false);
      String account = userState.account;
      await _userController.visitaGerente(userState.account);
      _carregarSaldo();
    } 
  }

  //transferencia
  void _realizarTrasnferencia() async{
    if(double.tryParse(_contaTrasnfController.text) != null && 
    double.tryParse(_valorTrasnfController.text) != null ){
      if(double.parse(_valorTrasnfController.text) <= _mySaldo){
        UserState userState = Provider.of<UserState>(context, listen: false);
        String account = userState.account;
        await realizarTransferencia(_userController, account, _contaTrasnfController.text,_valorTrasnfController.text, _carregarSaldo, _carregarExtrato, userState.perfil, context);
      }else{
        await showDialogPopUp(context, 'Transferencia', 'Sem Saldo para a Transferência');
      }
    }else{
      await showDialogPopUp(context, 'Transferencia', 'Preencha de forma certa');
    }
    _contaTrasnfController.clear();
    _valorTrasnfController.clear();
  }
  //deposito
  void _realizarDeposito() async {
    if(double.tryParse(_valorDepositoController.text) != null){
      UserState userState = Provider.of<UserState>(context, listen: false);
      String account = userState.account;
      await realizarDeposito(_userController, account,  _valorDepositoController.text, _carregarSaldo ,_carregarExtrato,context );
    }else{
      await showDialogPopUp(context, 'Deposito', 'Apenas valores numericos');
    }
    _valorDepositoController.clear();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conta Bancaria",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      drawer: Menu(_userController),
      body: Builder(
        builder: (context){
          return Consumer<UserState>(
            builder: (context,userState,_){
              return Container(
                decoration: BoxDecoration(
                  color:  Color(0xFF424549)
                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "SEU SALDO: R\$ ${_mySaldo.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                          ),
                        ),
                      ), 

                      DropdownButton<String>(
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down, 
                          color: Colors.orange,
                        ),
                        dropdownColor: Colors.grey, 
                        value: selectedAction,
                        items:actions
                        .where((action) => userState.perfil == "VIP" || action != "Gerente")
                        .map((String action) {
                          return DropdownMenuItem<String>(
                            value: action,
                            child: Text(action),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedAction = value ?? '';
                          });
                        },
                      ),
                      Visibility(
                        visible: selectedAction=='Deposito',
                        child:FieldText(
                          controller: _valorDepositoController,
                          labelText: 'Valor do depósito',
                          buttonText: 'Depositar',
                          onPressed: _realizarDeposito,
                        ), 
                      ),
                      Visibility(
                        visible: selectedAction == 'Saque',
                        child:FieldText(
                          controller: _valorSaqueController,
                          labelText: 'Valor do saque',
                          buttonText: 'Sacar',
                          onPressed: _realizarSaque,
                        ), 
                      ),
                      Visibility(
                        visible: selectedAction == 'Transferencia',
                        child:  FieldTrasnsferencia(
                          controllerAccount: _contaTrasnfController,
                          controllervalue: _valorTrasnfController,
                          labelTextAccount: 'numero da conta',
                          labelTextValue: 'Valor da transferencia',
                          buttonText: 'Transferir',
                          onPressed: _realizarTrasnferencia,
                        ), 
                      ),
                      Visibility(
                        visible: userState.perfil == "VIP" && 
                        selectedAction== "Gerente",
                        child: ElevatedButton(
                          onPressed: _visitaDoGerente,
                          child: Text(
                            "Solicitar visita do gerente",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                          ),
                          style: ButtonStyle(
                             backgroundColor:MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _transacoes.length,
                          itemBuilder: (context, index) {
                            Transacoes transacao = _transacoes[index];
                            DateTime dateTime = DateTime.parse(transacao.date);
                            return ListTile(
                              title: Text(
                                transacao.description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(dateTime),
                                 style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              // trailing: Text(transacao.amount.toString()),
                              trailing: Text(
                                transacao.amount < 0 ? '(-)${transacao.amount.abs()}' : transacao.amount.toString(),
                                 style: TextStyle(
                                  color: transacao.amount < 0 ? Colors.red : Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                    ],
                  ),
                ),
              );
            }
          );
        }
      )
    );
  }


}