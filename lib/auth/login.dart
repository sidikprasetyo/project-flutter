import 'dart:convert';
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:loginapi/interface/penjual/home_penjual.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:loginapi/interface/pembeli/home_pembeli.dart';
import 'package:loginapi/auth/signup.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //body: Text('Data'),
        body: const Project(),
      ),
    );
  }
}

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObsecure = true;

  Future<void> _login() async {
    var url =
        Uri.parse("https://sidikprast.000webhostapp.com/flutterapi/login.php");
    var response = await http.post(url, body: {
      "username": usernameController.text,
      //"password": passwordController.text
      "password": generateMD5(passwordController.text),
    });
    var datauser = jsonDecode(response.body);
    print(datauser);
    print(generateMD5(passwordController.text));
    if (datauser != '') {
      print('Login Sukses');
      if (datauser[0]['bagian'] == 'Penjual') {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyApp1(),
          ),
        );
      } else if (datauser[0]['bagian'] == 'Pembeli') {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyApp2(),
          ),
        );
      }
    } else {
      print('Login Gagal');
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraint) {
          return Container(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraint.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  Container(
                    child: Image(
                      height: 250,
                      width: 250,
                      image: AssetImage("assets/images/splash.png"),
                    ),
                  ),
                  Text(
                    "User Login",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'Username'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: TextFormField(
                      obscureText: _isObsecure,
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObsecure = !_isObsecure;
                                });
                              },
                              icon: Icon(_isObsecure == false
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => MyApp3(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          padding: MaterialStateProperty.all<
                                  EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 18)),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ));
        }),
        margin: EdgeInsets.only(left: 16, right: 16),
      ),
    );
  }
}

generateMD5(String data) {
  var content = Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}
