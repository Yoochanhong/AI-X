import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(7.5, 15),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
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
  bool isUplode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image != null
            ? Container(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 6.0.w,
                        height: 6.0.h,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    isUplode == false
                        ? Center(child: const CircularProgressIndicator())
                        : Container(),
                  ],
                ),
              )
            : DottedBorder(
                child: Container(
                  width: 6.0.w,
                  height: 6.0.w,
                  child: Center(child: Text('이미지를 업로드해주세요.')),
                ),
                dashPattern: [5, 3],
                color: Colors.black,
                borderType: BorderType.RRect,
                radius: Radius.circular(10.0),
              ),
      ),
      floatingActionButton: image != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    getImageFromGallery(ImageSource.gallery);
                  },
                  child: Icon(Icons.refresh),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    ImagePost(image!);
                    await Future.delayed(Duration(seconds: 5));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NextPage();
                    }));
                  },
                  child: Icon(Icons.send),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                getImageFromGallery(ImageSource.gallery);
              },
              child: Icon(Icons.camera_alt_sharp),
            ),
    );
  }

  Future<dynamic> ImagePost(XFile input) async {
    setState(() {
      isUplode = false;
    });
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
      setState(() {
        isUplode = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 100);
    setState(() {
      image = XFile(pickedFile!.path);
    });
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: PageController(
            initialPage: 0,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
                'http://192.168.50.219:5001/static/images/${index}_image.png');
          }),
    );
  }
}

class LodingPage extends StatelessWidget {
  const LodingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              '이미지 보내는중...',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
