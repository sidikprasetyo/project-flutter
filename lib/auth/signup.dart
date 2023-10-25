import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapi/auth/login.dart';
import 'package:loginapi/main.dart';
//import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:loginapi/interface/pembeli/home_pembeli.dart';
import 'package:loginapi/interface/penjual/home_penjual.dart';

main() {
  runApp(const MyApp3());
}

class MyApp3 extends StatelessWidget {
  const MyApp3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Text('Data'),
      body: const SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bagianController = TextEditingController();
  bool _isObsecure = true;

  Future<void> _signup() async {
    var url =
        Uri.parse("https://sidikprast.000webhostapp.com/flutterapi/signup.php");
    var response = await http.post(url, body: {
      "username": usernameController.text,
      "password": generateMD5(passwordController.text),
      "fullname": nameController.text,
      "bagian": bagianController.text,
    });

    var result2 = jsonDecode(response.body);
    if (result2 == 'Sukses') {
      print('Sukses');
      Navigator.of(context).pop();
    }

    if (result2 == 'username_exist') {
      print('username_exist');
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyApp3(),
        ),
      );
    }

    if (result2 == 'data tidak komplit') {
      print('data tidak komplit');
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
                    "User Register",
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
                          labelText: 'username'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
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
                          labelText: 'password',
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
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'nama'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: TextField(
                      controller: bagianController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'profil'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Isi profil sebagai : Penjual atau Pembeli",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        _signup();
                      },
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 18,
                        ),
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
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      margin: EdgeInsets.only(left: 16, right: 16),
    ));
  }
}

generateMD5(String data) {
  var content = Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}
