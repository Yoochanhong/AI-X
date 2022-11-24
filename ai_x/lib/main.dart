import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: imageFile != null
            ? Container(
                child: Image.file(imageFile!),
              )
            : Text('no image'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getFromgallery();
        },
        child: Icon(Icons.camera_alt_sharp),
      ),
    );
  }

  void getFromgallery() async {
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }
}
