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
  final _picker = ImagePicker();
  PickedFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getImage();
        },
        child: Icon(Icons.camera_alt_sharp),
      ),
    );
  }

  Future _getImage() async {
    PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = _image;
    });
  }
}