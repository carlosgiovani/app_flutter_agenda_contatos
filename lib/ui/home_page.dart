import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

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
                          AssetImage("images/person.svg")
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
        _showContactPage(contact: contacts[index]);
      },
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
        await helper.saveContact(recContact, contact);
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
}
