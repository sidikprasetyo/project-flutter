import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapi/auth/login.dart';

main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return MyApp();
          } else {

            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Colors.white12,
                body: Center(
                    child: Image(
                      width: 300,
                      height: 300,
                  image: AssetImage("assets/images/splash.png"),
                )),
              ),
            );
          }
        });
  }
}
