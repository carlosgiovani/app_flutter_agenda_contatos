import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  //Declaração do contato
  final Contact contact;
  //Construtor q recebe o contato - com parametro opcional prq a pag e de criação e edição
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;

  //Chamada quando a tela iniciar
  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact.fromMap((widget.contact.toMap()));
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_editedContact.name ?? "Novo Contato"),
      ),
    );
  }
}
