import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supply_chain_app/util/string.dart';
import 'package:supply_chain_app/util/text_styles.dart';
import 'custom_dialog.dart';

import 'next_scrren.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  bool logging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0,left: 30, right:30, bottom: 30),
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0,left: 10.0,bottom: 0.0,right: 10.0),
            child: Form(
              key: _loginKey,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset("assets/images/logo.png",height: 200.0,width:300.0,fit: BoxFit.cover,),
                      Text(Strings.MOTTO,style: TextStyles.motto_style)
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phone_controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Phone number",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.PHONE_VALIDATOR_ERROR;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: password_controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.PASSWORD_VALIDATOR_ERROR;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: logging ? Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child:  CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                      ) :
                      Text(
                        Strings.LOGIN,
                        style: TextStyles.logo_style
                      ),
                    ),
                    color: Colors.blue,
                    onPressed: () => loginClicked(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }


  http.Response response;

  loginClicked() async {
    setState(() {
      logging = true;
    });
    if (_loginKey.currentState.validate()) {

      var phone_num = phone_controller.text;
      var pass = password_controller.text;

      try {
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Map<String, String> body = {
            'phone': phone_num,
            'password': pass
          };

          response = await http.post(
              Strings.URL,
              body: body);

          var jsonResponse;

          if (response.body == 'Unauthorized') {
            setState(() {
              logging = false;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(Strings.INPUT_ERROR,Strings.INPUT_ERROR_DES,0);
                });
          } else {
            if (response.statusCode == 200) {
              setState(() {
                logging = false;
              });
              jsonResponse = jsonDecode(response.body);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NextScreen(),
                  settings:
                      RouteSettings(arguments: jsonResponse['user']['_id'])));
            } else {
              setState(() {
                logging = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(Strings.OTHER_ERROR,Strings.OTHER_ERROR_DES,1);
                  });
            }
          }
        }
      } on SocketException catch (_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(Strings.CONNECTION_ERROR,Strings.CONNECTION_DES,0);
            });
      }
    }
  }
}



