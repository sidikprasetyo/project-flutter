//import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

main() {
  runApp(Page1());
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Input Item')),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Input(),
      ));
}

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
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
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    var length = await imageFile.length();

    var uri =
        Uri.parse("https://sidikprast.000webhostapp.com/flutterapi/upload.php");
    var request = http.MultipartRequest("POST", uri);
    var multipartfile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.fields['title'] = ctitle.text;
    request.fields['price'] = cprice.text;
    request.files.add(multipartfile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Upload Sukses');
      Navigator.push(
          this.context, MaterialPageRoute(builder: (context) => Page1()));
    } else {
      print('Upload Gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset('assets/images/placeholder.png')
    );
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
                        height: 50,
                      ),
                      Text(
                        "Enter Item Data",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
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
                              "Save",
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
