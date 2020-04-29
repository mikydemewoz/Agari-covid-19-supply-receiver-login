import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NextScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NextScreenState();
  }
}

class NextScreenState extends State<NextScreen> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repasswordController = new TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _rePasswordNode = FocusNode();
  var nameError;
  var phoneError;
  var passwordError;
  var rePasswordError;
  bool _hasCharacter = false;
  bool _hasNumber = false;
  bool registering = false;

  @override
  void initState() {
    super.initState();
    nameError = null;
    phoneError = null;
    passwordError = "";
    rePasswordError = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () => {Navigator.of(context).pop()},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center()
    );
  }


}
