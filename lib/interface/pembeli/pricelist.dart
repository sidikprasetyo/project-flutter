import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Pricelist')),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Pricelist1(),
      ));
}

class Pricelist1 extends StatefulWidget {
  const Pricelist1({Key? key}) : super(key: key);

  @override
  State<Pricelist1> createState() => _PricelistState();
}

class _PricelistState extends State<Pricelist1> {
  bool error = false;
  bool dataloaded = false;
  String errmsg = "";
  var result;

  @override
  void initState() {
    _getData();
    super.initState();
  }

void _getData() async {
    setState(() {
      dataloaded = true;
    });

    try {
      String url = "https://sidikprast.000webhostapp.com/flutterapi/read.php?auth=sidikprasetyo";
      final response = await http.get(Uri.parse("$url"));
      result = json.decode(response.body);
    }
    catch (err) {
        error = true;
        errmsg = result["msg"];
    }
    setState(() {
      dataloaded = false;
    });
  }

/*
  void _getData() {
    Future.delayed(Duration.zero, () async {
      var url = Uri.parse(
          "https://sidikprast.000webhostapp.com/flutterapi/read.php?auth=sidikprasetyo");
      var response = await http.post(Uri.parse(url.toString()));
      if (response.statusCode == 200) {
        setState(() {
          result = json.decode(response.body);
          print(result);
          dataloaded = true;
        });
      } else {
        setState(() {
          error = true;
          errmsg = result["msg"];
        });
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
            alignment: Alignment.topCenter,
             padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
            child: dataloaded
                ? const CircularProgressIndicator()
                : //if loading == true, show progress indicator
                Container(
                    //if there is any error, show error message
                    child: error
                        ? Text("Error: $errmsg")
                        : Column(
                            //if everything fine, show the JSON as widget
                            children: result["data"].map<Widget>((music) {
                              return Card(
                                child: ListTile(
                                    title: Text(music["title"]),
                                    subtitle: Text("IDR. "+music["price"]),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(music["image"]),
                                    )),
                              );
                            }).toList(),
                          )))
      ],
    ));
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(15),
      child: dataloaded
          ? datalist()
          : const Center(child: CircularProgressIndicator()),
    ));
  }

  Widget datalist() {
    if (result["error"] != null) {
      return Text(result["errmsg"]);
    } else {
      List<DataModel> namelist = List<DataModel>.from(result["data"].map((i) {
        return DataModel.fromJSON1(i);
      }));

      return ListView(
        children: [
          Table(
            border: TableBorder.all(width: 1, color: Colors.black45),
            children: namelist.map((dataModel) {
              return TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(dataModel.id1))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(dataModel.image1))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(dataModel.title1))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(dataModel.description1))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(dataModel.price1))),
              ]);
            }).toList(),
          ),
        ],
      );
    }
  }
  */
}
