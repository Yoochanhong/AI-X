import 'dart:io';

import 'package:dio/dio.dart';
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
  XFile? image;
  String fileUploadUrl = 'http://192.168.50.219:5001/fileUpload';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image != null
            ? Container(
                child: Column(
                  children: [
                    Container(
                      width: 500,
                      height: 500,
                      child: Image.file(File(image!.path)),
                    ),
                  ],
                ),
              )
            : Text('no image'),
      ),
      floatingActionButton: image != null
          ? FloatingActionButton(
              onPressed: () {
                ImagePost(image!);
              },
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
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 100);
    setState(() {
      image = XFile(pickedFile!.path);
    });
  }

  void ImagePost(XFile input) async {
    print("사진을 서버에 업로드 합니다.");
    var dio = new Dio();
    var formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(input!.path)});
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var response = await dio.post(
        fileUploadUrl,
        data: formData,
      );
      print('성공적으로 업로드했습니다');
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
