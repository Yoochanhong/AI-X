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
  File? image;
  Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image != null
            ? Container(
                child: Column(
                  children: [
                    Image.file(image!),
                  ],
                ),
              )
            : Text('no image'),
      ),
      floatingActionButton: image != null
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.send),
            )
          : FloatingActionButton(
              onPressed: () {
                getImageFromGallery(ImageSource.gallery);
              },
              child: Icon(Icons.camera_alt_sharp),
            ),
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      image = File(pickedFile!.path);
    });
  }
}
