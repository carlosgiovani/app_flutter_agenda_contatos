import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: <Widget>[
          //menu tipo popover do ionic
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
      ),
    );
  }

  // Função para criação do card de contatos
  Widget _contactCard(BuildContext context, int index){
    //GestureDetector detecta o toque no item
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                          FileImage(File(contacts[index].img)) :
                          AssetImage("images/person.svg"),
                    fit: BoxFit.cover //imagem arredondada
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18.0
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18.0
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      //Passando o contato clicado para tela de edição
      onTap: (){
        _showOptions(context, index);
      },
    );
  }
  
  //Função para abrir menu de opções ao clicar no contato
  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},  //Função para fechar.
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,  //faz com q o menu aerto ocupe o minimo de espaço possivel
                  children: <Widget>[
                    Padding(
                      child: FlatButton(
                        child: Text("Ligar", style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                        ),
                        onPressed: (){
                          launch("tel:${contacts[index].phone}"); // funcao para abrir o telefone e ligar para o numero do contato
                          Navigator.pop(context);  //fecha a a janela de opçoes
                        },
                      ),
                    ),
                    Padding(
                      child: FlatButton(
                        child: Text("Editar", style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);  //fecha a janela antes de mudar para tela de edição
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      child: FlatButton(
                        child: Text("Excluir", style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                        ),
                        onPressed: (){
                          helper.deleteContact(contacts[index].id); //remover o contata
                          setState(() {
                            contacts.removeAt(index);  //remove o contato da lista
                            Navigator.pop(context);  //fecha a a janela de opçoes
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }
  
  
  
  // Função para chamar a tela de edição/criação de contatos(contact_page) e,
  // enviar e receber contatos
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContact().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

  // Funcao para ordernar a lista de contatos
  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase()); //compara nome A com nome B e ordena
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase()); //compara nome B com nome A e ordena
        });
        break;
    }
    setState(() {

    });
  }
}
