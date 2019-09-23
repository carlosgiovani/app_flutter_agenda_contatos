import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final _nameFocus = FocusNode();

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
    return WillPopScope( //willpopscope chama um função ao clicar na seta de voltar
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //Retorna para tela principal
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            } else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
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
                        AssetImage("images/person.svg"),
                      fit: BoxFit.cover //Imagem arredondada
                    ),
                  ),
                ),
                onTap: (){ //funcao para abrir a camera e tirar a foto do usuario
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
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
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar Alterações??"),
            content: Text("Se sair as alterações serão perdidas"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sair"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false); //nao deixa sair automaticamente se modificou algo
    } else{
      return Future.value(true); //deixa sair automaticamente se nao modificou nada
    }
  }
}
