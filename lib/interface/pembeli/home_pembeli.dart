import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapi/interface/pembeli/pricelist.dart';

main() {
  runApp(MyApp2());
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('DISTORTION.ID'),
          backgroundColor: Colors.indigo,
        ),
        drawer: _buildDrawer(context),
        body: const Project01(),
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return SizedBox(
    //membuat menu drawer
    child: Drawer(
      //membuat list,
      //list digunakan untuk melakukan scrolling jika datanya terlalu panjang
      child: ListView(
        padding: EdgeInsets.zero,
        //di dalam listview ini terdapat beberapa widget drawable
        children: [
          const UserAccountsDrawerHeader(
            //membuat gambar profil
            currentAccountPicture: Image(
                image: AssetImage("assets/images/avatar.png"),),
            //membuat nama akun
            accountName: Text("Buyer"),
            //membuat nama email
            accountEmail: Text("This page is accessible to all buyers"),
            //memberikan background
            decoration: BoxDecoration(
                color: Colors.indigo),
          ),
          //membuat list menu
          ListTile(
            leading: Icon(Icons.price_change),
            title: Text("Pricelist"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Page4()));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log Out"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}

class Project01 extends StatefulWidget {
  const Project01({super.key});

  @override
  State<Project01> createState() => _Project01State();
}

class _Project01State extends State<Project01> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Container(
            padding: const EdgeInsets.only(top: 0),
            child: const Image(
              height: 250,
              width: 250,
              image: AssetImage("assets/images/splash.png"),
            ),
          ),
           Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: const Text(
                'You Sign in as a buyer',
                style: TextStyle(fontSize: 20, color: Colors.indigo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
