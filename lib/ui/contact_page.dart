import 'dart:io';

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

  //Controllers para pegar os dados de contatos
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userEdited = false;
  Contact _editedContact;

  //Chamada quando a tela iniciar
  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact.fromMap((widget.contact.toMap()));
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      //preenche os campos com os dados existentes
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.img != null ?
                        FileImage(File(_editedContact.img)) :
                        AssetImage("images/person.svg")
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text){
                _userEdited = true;
                _editedContact.email = text;
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.phone = text;
                });
              },
              keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    );
  }
}
