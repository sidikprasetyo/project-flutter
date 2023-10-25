//import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:io/io.dart';
import 'package:loginapi/interface/penjual/pricelist.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class EditPage extends StatefulWidget {
  final Map ListData;
  EditPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditPage> createState() => _EditState();
}

class _EditState extends State<EditPage> {
  TextEditingController cid = TextEditingController();
  TextEditingController ctitle = TextEditingController();
  TextEditingController cprice = TextEditingController();

  File? pictureFile;

  Future _imageGalery() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;
      var pictureTemp = File(imageFile.path);
      setState(() {
        pictureFile = File(pictureTemp.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future _upload(File imageFile) async {
    if (pictureFile == null) {
    print('No image selected.');
    return;
  }
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    var length = await imageFile.length();

    var uri =
        Uri.parse("https://sidikprast.000webhostapp.com/flutterapi/edit.php");
    var request = http.MultipartRequest("POST", uri);
    var multipartfile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.fields['id_barang'] = cid.text;
    request.fields['title'] = ctitle.text;
    request.fields['price'] = cprice.text;
    request.files.add(multipartfile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Update Sukses');
      Navigator.push(
          this.context, MaterialPageRoute(builder: (context) => Page2()));
    } else {
      print('Update Gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    cid.text = widget.ListData["id_barang"];
    ctitle.text = widget.ListData["title"];
    cprice.text = widget.ListData["price"];
     var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset('assets/images/placeholder.png')
    );
    

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Edit Item')),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
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
                        height: 50,
                      ),
                      Text(
                        "Change Item Data",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      /*
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _imageGalery();
                            },
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text(
                              "Upload Picture",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
                        width: double.infinity,
                      ),
                      */
                      SizedBox(
                        height: 16,
                      ),
                     Container(
                        width: double.infinity,
                        height: 150,
                        child:InkWell(
                          onTap: () {
                            _imageGalery();
                          },
                          child: pictureFile == null
                          ?placeholder
                          :Image.file(pictureFile!)
                        )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: TextField(
                          controller: ctitle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            labelText: 'Title',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        child: TextField(
                          controller: cprice,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            labelText: 'Price',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _upload(pictureFile!);
                            },
                            icon: const Icon(Icons.file_upload),
                            label: const Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)))),
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
          },
        ),
        margin: EdgeInsets.only(left: 16, right: 16),
      ),
    );
  }
}
